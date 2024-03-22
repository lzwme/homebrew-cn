cask "buttercup" do
  version "2.26.2"
  sha256 "444ba6e22f2625b9a1fe28b6b7d4db3b227425f75f7079a47cdaabae29f80b35"

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