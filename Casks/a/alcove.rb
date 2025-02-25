cask "alcove" do
  version "1.2.5"
  sha256 "2bed32a02a8df7dd5edb2bf2af54b9d3e99c77382f81751c840d57aa5fe88dac"

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