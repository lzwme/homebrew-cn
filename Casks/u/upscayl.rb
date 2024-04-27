cask "upscayl" do
  version "2.11.0"
  sha256 "632506a5d5c92593ac9f81707c067c0846d1b80647b3b3864748a9839d6dcfab"

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