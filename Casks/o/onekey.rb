cask "onekey" do
  arch arm: "arm64", intel: "x64"

  version "5.2.0"
  sha256 arm:   "245f341ebad012c4c6b6b7329c3dcfe4196e500fe93a1a3942b798cf175bd719",
         intel: "f1afdee32a9806a8f3ceb5b2787c3b3a9caba65ad8ad7a66745c6bc2484cc492"

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