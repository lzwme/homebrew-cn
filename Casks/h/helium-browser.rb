cask "helium-browser" do
  arch arm: "arm64", intel: "x86_64"

  version "0.11.5.1"
  sha256 arm:   "3f9897b574b4e6ebb9432f633e179701b8dec27ea329372a739b85db2668cff9",
         intel: "608d1ce430ed3e2cebfe6b830a2f1b5aedf053de960f1c3acbc6e608e6fab30d"

  url "https://ghfast.top/https://github.com/imputnet/helium-macos/releases/download/#{version}/helium_#{version}_#{arch}-macos.dmg",
      verified: "github.com/imputnet/helium-macos/"
  name "Helium"
  desc "Chromium-based web browser"
  homepage "https://helium.computer/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Helium.app"

  zap trash: [
    "~/Library/Application Support/net.imput.helium",
    "~/Library/Caches/net.imput.helium",
    "~/Library/HTTPStorages/net.imput.helium",
    "~/Library/Preferences/net.imput.helium.plist",
  ]
end