cask "linearmouse" do
  version "0.10.1"
  sha256 "94f8318c693898afd6ac8c471e08b40d76c9b1c3191fc995fa8159c25b2f25fb"

  url "https://dl.linearmouse.org/v#{version}/LinearMouse.dmg"
  name "LinearMouse"
  desc "Customise mouse behavior"
  homepage "https://linearmouse.org/"

  livecheck do
    url "https://linearmouse.app/appcast.xml"
    strategy :sparkle do |items|
      items.find { |item| item.channel.nil? }&.nice_version
    end
  end

  auto_updates true
  conflicts_with cask: "linearmouse@beta"

  app "LinearMouse.app"

  uninstall quit:       "com.lujjjh.LinearMouse",
            login_item: "LinearMouse"

  zap trash: [
    "~/.config/linearmouse",
    "~/Library/Preferences/com.lujjjh.LinearMouse.plist",
  ]
end