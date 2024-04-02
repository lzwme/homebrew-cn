cask "buttercup" do
  version "2.27.0"
  sha256 "ee56e253edcdb5b70a006c9b57ac38903e0fbf84409f07ba2a95c57add3fbe83"

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