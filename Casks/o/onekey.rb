cask "onekey" do
  arch arm: "arm64", intel: "x64"

  version "5.10.0"
  sha256 arm:   "7dcdc8f740f45dee6f7f8d8961a4c6275f46daab76b2ea97c38736f35c786bd7",
         intel: "386a4a7d9e816200a2b630cb7e201c846d22c12d46d3925e0e8912e81a27d4b7"

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