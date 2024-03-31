cask "buttercup" do
  version "2.26.4"
  sha256 "2c265eca067d306ba1a8e22d936745cd48e4d46bd759189b9dee0e6d602a9fb7"

  url "https:github.combuttercupbuttercup-desktopreleasesdownloadv#{version}Buttercup-mac-x64-#{version}.dmg",
      verified: "github.combuttercupbuttercup-desktop"
  name "Buttercup"
  desc "Javascript Secrets Vault - Multi-Platform Desktop Application"
  homepage "https:buttercup.pw"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Buttercup.app"

  zap trash: [
    "~LibraryApplication SupportButtercup",
    "~LibraryApplication SupportButtercup-nodejs",
    "~LibraryLogsButtercup-nodejs",
    "~LibraryPreferencesButtercup-nodejs",
    "~LibraryPreferencespw.buttercup.desktop.plist",
    "~LibrarySaved Application Statepw.buttercup.desktop.savedState",
  ]
end