cask "alcove" do
  version "1.2.0"
  sha256 "b478d1cd642ec5d6fc2b1793ebdd464ef2d1f294a8a8a03b9b808ddc4f92992b"

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