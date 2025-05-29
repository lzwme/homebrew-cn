cask "megasync" do
  arch arm: "Arm64"

  version "5.12.0.1"
  sha256 :no_check

  url "https:mega.nzMEGAsyncSetup#{arch}.dmg"
  name "MEGAsync"
  desc "Syncs files between computers and MEGA Cloud drives"
  homepage "https:mega.nzsync"

  livecheck do
    url "https:github.commeganzMEGAsync"
    regex(^v?(\d+(?:\.\d+)+)[._-]OSX$i)
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "MEGAsync.app"

  uninstall launchctl:  "mega.mac.megaupdater",
            quit:       "mega.mac",
            login_item: "MEGAsync"

  zap trash: [
    "~LibraryApplication Scriptsmega.mac.MEGAShellExtFinder",
    "~LibraryCachesmega.mac",
    "~LibraryContainersmega.mac.MEGAShellExtFinder",
    "~LibraryLaunchAgentsmega.mac.megaupdater.plist",
    "~LibraryPreferencesmega.mac.plist",
  ]
end