cask "onekey" do
  arch arm: "arm64", intel: "x64"

  version "5.7.1"
  sha256 arm:   "c5b115cb4ea989653f5e5ad981f32772a7090e835ec32142d9dafac8fa197be3",
         intel: "23c8f40f1b0419f273601a53770351a69be6d9304b618299572f8d021dc9718b"

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