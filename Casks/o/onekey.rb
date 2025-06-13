cask "onekey" do
  arch arm: "arm64", intel: "x64"

  version "5.9.0"
  sha256 arm:   "c308cd621719ef6ff933b1ca726e89af2fe872c7e115c846a0fe40da54bcd627",
         intel: "9d5fd3e2d0c70b8350795acbe6fc073402ecae3730345fdc7dc9bce457e10c14"

  url "https:github.comOneKeyHQapp-monoreporeleasesdownloadv#{version}OneKey-Wallet-#{version}-mac-#{arch}.dmg",
      verified: "github.comOneKeyHQapp-monorepo"
  name "OneKey"
  desc "Crypto wallet"
  homepage "https:onekey.so"

  livecheck do
    url "https:data.onekey.soconfig.json"
    strategy :json do |json|
      json.dig("desktop", "version")&.join(".")
    end
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