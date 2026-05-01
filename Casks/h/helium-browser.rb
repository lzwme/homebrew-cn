cask "helium-browser" do
  arch arm: "arm64", intel: "x86_64"

  version "0.11.7.1"
  sha256 arm:   "8dbbbfc37fc6602eb41acd2e79e102adb7830d22c0a1714c6a7aae229c3456f3",
         intel: "545dc4b2186c6b1fcd241047f3cfc2cb3e0500f2152e50035a0fbee1b5fb4dbe"

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