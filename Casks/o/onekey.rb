cask "onekey" do
  arch arm: "arm64", intel: "x64"

  version "5.1.0"
  sha256 arm:   "8964df00bbd32898e1f65bba766b122ab6a2a8be9799d229fe892665ba14bb6c",
         intel: "287ec8c3c16c0de2b6ae946bdd622d13c124832ca056cceadc5d47b0f97ab0eb"

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