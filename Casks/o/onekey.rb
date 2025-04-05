cask "onekey" do
  arch arm: "arm64", intel: "x64"

  version "5.7.0"
  sha256 arm:   "0fbb5f1d8323718be81ad9389d571029d10a0b56c269ce34c8a782a9c77b0ca5",
         intel: "e6220cf9dc2c6eb8c5734ec251da13ce0cc878b6cbd31f3653744871aa703a9b"

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