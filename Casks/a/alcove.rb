cask "alcove" do
  version "1.1.0"
  sha256 "28ac86cc7361da7137d9e06406f8f034bd35c6d1208875b92719b612ef448ceb"

  url "https:github.comhenrikrusconalcove-releasesreleasesdownload#{version}Alcove.zip",
      verified: "github.comhenrikrusconalcove-releases"
  name "Alcove"
  desc "Utility to add Dynamic Island like features to notch area"
  homepage "https:tryalcove.com"

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "Alcove.app"

  zap trash: [
    "~LibraryCachescom.henrikruscon.Alcove",
    "~LibraryHTTPStoragescom.henrikruscon.Alcove",
    "~LibraryPreferencescom.henrikruscon.Alcove.plist",
  ]
end