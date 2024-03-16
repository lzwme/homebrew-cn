cask "onekey" do
  arch arm: "arm64", intel: "x64"

  version "4.22.0"
  sha256 arm:   "c1eef28d1a223e34b3925c4dbc00d9bf57917688900289f3a461bb9423155172",
         intel: "cd4a5967b2db9f8d56949fb0cbd38df5018340eb467bc1e498ec3c2829924e3a"

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