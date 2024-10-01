cask "lectrote" do
  version "1.5.0"
  sha256 "27974651944ae93fe7a876c45d3c24212fb33cc3f0c852fb7839f9557225f8f6"

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