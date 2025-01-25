cask "onekey" do
  arch arm: "arm64", intel: "x64"

  version "5.6.0"
  sha256 arm:   "ef0f1afe88a65bbc97f6a2886d2962db2fbcda4c2716f98ead6d90b80fe9797c",
         intel: "68ce897423f6dee0f1d8df691721b2b37d03400ae775d46ee779a20e9f3e1216"

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