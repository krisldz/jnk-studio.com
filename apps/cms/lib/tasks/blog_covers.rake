# Pobiera okładki wpisów bloga ze stocka Unsplash, dopasowane do kategorii.
# Wymaga klucza: UNSPLASH_ACCESS_KEY (demo app = 50 zapytań/h).
# Uruchom:  docker compose exec -e UNSPLASH_ACCESS_KEY=xxx backend bin/rails blog:covers
# Idempotentny: pomija wpisy, które już mają okładkę. Opcjonalnie LIMIT=N.
require "net/http"
require "json"

namespace :blog do
  QUERIES = {
    "kuchnia" => "modern kitchen interior",
    "lazienka" => "modern bathroom interior",
    "sypialnia" => "cozy bedroom interior design",
    "pokoj-dzieciecy" => "kids room interior",
    "salon-jadalnia" => "living room interior design",
    "male-wnetrza" => "small apartment interior",
    "oswietlenie" => "interior lighting lamp",
    "kolory-materialy" => "interior wall colour texture",
    "dekoracje-dodatki" => "home decor accessories",
    "meble-przechowywanie" => "wardrobe storage interior",
    "style-wnetrz" => "scandinavian interior design",
    "porady-inspiracje" => "interior design home"
  }.freeze

  desc "Pobierz okładki wpisów z Unsplash wg kategorii"
  task covers: :environment do
    key = ENV["UNSPLASH_ACCESS_KEY"].to_s
    abort "Brak UNSPLASH_ACCESS_KEY" if key.blank?
    limit = ENV["LIMIT"]&.to_i

    fetched = 0
    PostCategory.ordered.each do |cat|
      query = QUERIES[cat.slug(:pl)] || "interior design"
      posts = cat.posts.reject { |p| p.cover.attached? }
      posts = posts.first(limit - fetched) if limit && limit - fetched < posts.size
      next if posts.empty?

      pool = []
      posts.each do |post|
        if pool.empty?
          # /photos/random zwraca do 30 losowych; nie liczy pobrań zdjęć do limitu API
          count = [ posts.size, 30 ].min
          uri = URI("https://api.unsplash.com/photos/random")
          uri.query = URI.encode_www_form(query: query, orientation: "landscape",
                                          content_filter: "high", count: count)
          req = Net::HTTP::Get.new(uri)
          req["Authorization"] = "Client-ID #{key}"
          res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
          unless res.is_a?(Net::HTTPSuccess)
            warn "[covers] Unsplash #{res.code} dla '#{query}': #{res.body[0, 200]}"
            break
          end
          pool = JSON.parse(res.body)
          pool = [ pool ] unless pool.is_a?(Array)
        end
        photo = pool.shift
        next unless photo && photo.dig("urls", "regular")

        # Wymóg Unsplash: wyzwól "download" event dla pobranego zdjęcia.
        if (dl = photo.dig("links", "download_location"))
          begin
            u = URI(dl)
            dreq = Net::HTTP::Get.new(u)
            dreq["Authorization"] = "Client-ID #{key}"
            Net::HTTP.start(u.host, u.port, use_ssl: true) { |h| h.request(dreq) }
          rescue StandardError => e
            warn "[covers] download_location: #{e.message}"
          end
        end

        img = URI.parse(photo["urls"]["regular"] + "&w=1200&q=80")
        bytes = Net::HTTP.get(img)
        post.cover.attach(io: StringIO.new(bytes),
                          filename: "cover-#{post.id}.jpg", content_type: "image/jpeg")
        # Atrybucja autora (wymóg Unsplash): nazwisko + link do profilu z UTM.
        profile = photo.dig("user", "links", "html")
        profile = "#{profile}?utm_source=jnk_studio&utm_medium=referral" if profile.present?
        post.update_columns(cover_credit: photo.dig("user", "name"), cover_credit_url: profile)
        fetched += 1
        print "."
      end
      puts " #{cat.name(:pl)}: +#{posts.size}"
      break if limit && fetched >= limit
    end
    puts "[covers] dopięto okładek: #{fetched}"
  end
end
