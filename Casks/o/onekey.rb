cask "onekey" do
  arch arm: "arm64", intel: "x64"

  version "5.1.2"
  sha256 arm:   "b9d9a78720db474b0b79baffc3da00c298ce10fa668c14500a9e0afa3d1e3a89",
         intel: "3c92b84a78cdf5264921b774295760f8cdeb3c0bd5a5ab5a81dd3e5178a0ae36"

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