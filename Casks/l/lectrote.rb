cask "lectrote" do
  version "1.4.6"
  sha256 "52d890a6685121d56dce401dcc76ef520885137c52d99f3a62777ac949182370"

  url "https:github.comerkyrathlectrotereleasesdownloadlectrote-#{version}Lectrote-#{version}-macos-universal.dmg"
  name "lectrote"
  desc "Interactive Fiction interpreter in an Electron shell"
  homepage "https:github.comerkyrathlectrote"

  app "Lectrote.app"

  zap trash: [
    "~LibraryApplication SupportLectrote",
    "~LibraryPreferencescom.eblong.lectrote.plist",
  ]
end