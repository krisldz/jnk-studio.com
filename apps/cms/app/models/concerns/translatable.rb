# Tłumaczone atrybuty przechowywane w kolumnach JSONB w formacie {"pl" => "...", "en" => "..."}.
#
#   class Project < ApplicationRecord
#     include Translatable
#     translates :title, :lead
#   end
#
#   project.title              # => wartość w I18n.locale, fallback do PL
#   project.title(:en)         # => wartość EN, fallback do PL
#   project.title_translations # => cały hash
#   project.title = { pl: "…", en: "…" }  # ustaw wszystkie języki
#
# Walidacja wymaga obecności wartości w domyślnym języku (PL).
module Translatable
  extend ActiveSupport::Concern

  included do
    class_attribute :translatable_attributes, instance_writer: false, default: []
  end

  class_methods do
    def translates(*attributes)
      self.translatable_attributes += attributes

      attributes.each do |attribute|
        # Odczyt: project.title lub project.title(:en)
        define_method(attribute) do |locale = I18n.locale|
          translations = read_attribute(attribute) || {}
          translations[locale.to_s].presence ||
            translations[I18n.default_locale.to_s].presence
        end

        # Pełny hash tłumaczeń.
        define_method("#{attribute}_translations") do
          read_attribute(attribute) || {}
        end

        # Zapis: hash (wszystkie języki) albo pojedyncza wartość w bieżącym języku.
        define_method("#{attribute}=") do |value|
          if value.is_a?(Hash)
            write_attribute(attribute, value.stringify_keys)
          else
            current = (read_attribute(attribute) || {}).dup
            current[I18n.locale.to_s] = value
            write_attribute(attribute, current)
          end
        end

        # Akcesory per-język (np. title_pl / title_en) — wygodne w formularzach.
        I18n.available_locales.each do |locale|
          define_method("#{attribute}_#{locale}") do
            (read_attribute(attribute) || {})[locale.to_s]
          end

          define_method("#{attribute}_#{locale}=") do |value|
            current = (read_attribute(attribute) || {}).dup
            current[locale.to_s] = value
            write_attribute(attribute, current)
          end
        end

        # Wymagany domyślny język (PL).
        validate do
          translations = read_attribute(attribute) || {}
          if translations[I18n.default_locale.to_s].blank?
            errors.add(attribute, :blank)
          end
        end
      end
    end
  end
end
