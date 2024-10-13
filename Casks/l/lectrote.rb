cask "lectrote" do
  version "1.5.1"
  sha256 "51599ce027c304d21f9a660f61051e6d2e0cc5e40f1567a57468726fb4b4db83"

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