cask "onekey" do
  arch arm: "arm64", intel: "x64"

  version "4.24.0"
  sha256 arm:   "36fb748849348fadbd25bceb917dc792c58383336c086ec8773a7f2a6dda07ff",
         intel: "5f387c44247498ebdb908b1fc28615f6bd356d9a51af8cf9e8be0fd71bdc79b9"

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