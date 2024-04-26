cask "upscayl" do
  version "2.11.0"
  sha256 "8cd9db46126d8108d99df0da9356748e0d1a13b877a5ed017ce2e56804e85eb1"

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