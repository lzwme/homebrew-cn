cask "buttercup" do
  version "2.26.0"
  sha256 "5f9bfee62ff525747c6aa6c135f95b810bb3071a0433da5c10c234750b73d4b4"

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