cask "onekey" do
  arch arm: "arm64", intel: "x64"

  version "5.5.0"
  sha256 arm:   "3957225476a56d91bf25e73af8fca91f85c2e20ddccd5a36689bed8a2509f183",
         intel: "b12016d280a027be8ace1b96dfc863e6dddf30308940a31d56da32a8e495685c"

  url "https:github.comOneKeyHQapp-monoreporeleasesdownloadv#{version}OneKey-Wallet-#{version}-mac-#{arch}.dmg",
      verified: "github.comOneKeyHQapp-monorepo"
  name "OneKey"
  desc "Crypto wallet"
  homepage "https:onekey.so"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "OneKey.app"

  zap trash: [
    "~LibraryApplication Support@onekeyhq",
    "~LibraryLogs@onekeyhq",
    "~LibraryPreferencesso.onekey.wallet.desktop.plist",
    "~LibrarySaved Application Stateso.onekey.wallet.desktop.savedState",
  ]
end