cask "onekey" do
  arch arm: "arm64", intel: "x64"

  version "5.8.0"
  sha256 arm:   "7e19ea8afae082905b7c1ba0771073b2b8e6cfcebe92870059a7b655611dad33",
         intel: "afc9692bff7020410932c9d3daee800f24f71da402dcf8ef288bb0bdd9dc4539"

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