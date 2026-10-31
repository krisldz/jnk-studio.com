json.locale I18n.locale
json.projects @projects do |project|
  json.partial! "api/v1/projects/project", project: project
end
