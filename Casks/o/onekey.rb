cask "onekey" do
  arch arm: "arm64", intel: "x64"

  version "4.21.0"
  sha256 arm:   "e70e663e883f582067a35c8e748438a0197797c77a03f673a579fa844f88f247",
         intel: "dbd280a731fcad671e5c529dbde111ad0e6e5f35b8a8cb02ec00eb817e11a436"

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