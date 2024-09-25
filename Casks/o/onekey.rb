cask "onekey" do
  arch arm: "arm64", intel: "x64"

  version "5.2.1"
  sha256 arm:   "7ffbb33da96687daf899923efaee3cefee01910aaf1c97471c9744018aefaf0d",
         intel: "a397a766a7e8d203a2ef0d30d407d08cd9ce328f13e30d810c150dd7e8e739ef"

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