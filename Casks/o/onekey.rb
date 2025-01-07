cask "onekey" do
  arch arm: "arm64", intel: "x64"

  version "5.5.1"
  sha256 arm:   "3be859bb3f8b1237af64556c9872e0b5463071225de691edec2f17fd54fe841a",
         intel: "2b07490e0ba859550a47d9e6e15376c76e6beb695bc3ea7796ffd6eb2f60cbb9"

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
  depends_on macos: ">= :catalina"

  app "OneKey.app"

  zap trash: [
    "~LibraryApplication Support@onekeyhq",
    "~LibraryLogs@onekeyhq",
    "~LibraryPreferencesso.onekey.wallet.desktop.plist",
    "~LibrarySaved Application Stateso.onekey.wallet.desktop.savedState",
  ]
end