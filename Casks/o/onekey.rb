cask "onekey" do
  arch arm: "arm64", intel: "x64"

  version "5.4.0"
  sha256 arm:   "9fa0c1711cd545fcd6a129c3e9c9f247d37902dee3d9528cccdf40b4229b08b2",
         intel: "4d3d54cb4cd8c98563520726e2b8144ab08ba36da70caee9e2343d0251e71d57"

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