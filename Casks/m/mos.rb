cask "mos" do
  version "3.5.0"
  sha256 "a361f871f32e763a101df29e57839188ef7fb33a289853f420fe83e9e70c008e"

  url "https://ghfast.top/https://github.com/Caldis/Mos/releases/download/#{version}/Mos.Versions.#{version}.dmg",
      verified: "github.com/Caldis/Mos/"
  name "Mos"
  desc "Smooths scrolling and set mouse scroll directions independently"
  homepage "https://mos.caldis.me/"

  no_autobump! because: :requires_manual_review

  app "Mos.app"

  zap trash: "~/Library/Preferences/com.caldis.Mos.plist"
end