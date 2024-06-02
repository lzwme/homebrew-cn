cask "upscayl" do
  version "2.11.5"
  sha256 "abf7b625641560cfa180dd1b2b0864138559d29f2a3d0f9951e5034496ce8dac"

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