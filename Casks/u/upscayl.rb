cask "upscayl" do
  version "2.15.0"
  sha256 "0e53c9ee8c1800cb3e2ce0f574e4e1a35a51945e19ff2b93f33928bbd7fd4c5a"

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