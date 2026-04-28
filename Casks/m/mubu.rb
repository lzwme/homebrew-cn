cask "mubu" do
  arch arm: "-arm64"

  version "5.5.2"
  sha256 arm:   "32ac462ca9a51fc45627dcf5c70990cb4d0a2c7eb7babc8f33ec134273fec483",
         intel: "f6561e7d53af68ae1f519419ff282214b6718512a549cbd34525f1774683efe1"

  url "https://assets.mubu.com/client/#{version}/Mubu-#{version}#{arch}.dmg"
  name "Mubu"
  desc "Outline note taking and management app"
  homepage "https://mubu.com/"

  livecheck do
    url "https://api2.mubu.com/v3/api/desktop_client/latest_version"
    strategy :json do |json|
      json.dig("data", "mac")
    end
  end

  auto_updates true
  depends_on :macos

  app "幕布.app"

  zap trash: [
    "~/Library/Application Support/幕布",
    "~/Library/Preferences/com.mubu.desktop.plist",
    "~/Library/Saved Application State/com.mubu.desktop.savedState",
  ]
end