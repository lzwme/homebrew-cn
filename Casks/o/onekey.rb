cask "onekey" do
  arch arm: "arm64", intel: "x64"

  version "4.19.0"
  sha256 arm:   "b76484241df57f5668d7a172eeaca7d38cb34b162a7d7b97a2b27ec6bc846400",
         intel: "75742281262bc466692261530ae1c28a76d0e28db1c15747be15016b5ed5cfe4"

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