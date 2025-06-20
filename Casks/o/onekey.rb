cask "onekey" do
  arch arm: "arm64", intel: "x64"

  version "5.9.2"
  sha256 arm:   "b99a036d4c7e2820a67663d4ba0e237ab567ac32a20b630733b94995fdb3f320",
         intel: "5499463bb5e00c1a607035b63f2cf3bdd08a4b9f26fd8a33ad62d8cc7e70cde9"

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