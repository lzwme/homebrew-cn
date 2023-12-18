cask "lectrote" do
  version "1.4.5"
  sha256 "e0aca6c4348e9e96a45a81c4f38a937686f59f492d391d626fcb9f8791a63b4f"

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