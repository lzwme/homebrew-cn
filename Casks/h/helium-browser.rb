cask "helium-browser" do
  arch arm: "arm64", intel: "x86_64"

  version "0.11.6.1"
  sha256 arm:   "069fa3f70a44f0e31ead0bb5ac299778958dfb4c89d28454296f963352231397",
         intel: "ef90e3ea9ee2de96a6a3e1993d0bf70d781e6978c57ad9797178fc7e24ca366e"

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