cask "upscayl" do
  version "2.10.0"
  sha256 "af929c724cd0b9ca8fec3f9a123b3c775812969ad4e2143ed2d3fceeb339a6be"

  url "https:github.comupscaylupscaylreleasesdownloadv#{version}upscayl-#{version}-mac.dmg",
      verified: "github.comupscaylupscayl"
  name "Upscayl"
  desc "AI image upscaler"
  homepage "https:upscayl.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "Upscayl.app"

  zap trash: [
    "~LibraryApplication SupportUpscayl",
    "~LibraryPreferencesorg.upscayl.app.plist",
    "~LibrarySaved Application Stateorg.upscayl.app.savedState",
  ]
end