cask "iconizer" do
  version "2020.11.0"
  sha256 "abaffdea473f4d3cd7d763fcb3846fbb752b87949e6ef7d273a95b6f5c5c1e06"

  url "https://ghfast.top/https://github.com/raphaelhanneken/iconizer/releases/download/#{version}/Iconizer.dmg",
      verified: "github.com/raphaelhanneken/iconizer/"
  name "Iconizer"
  desc "Xcode asset catalog creator"
  homepage "https://raphaelhanneken.com/iconizer/"

  livecheck do
    url "https://raphaelhanneken.github.io/iconizer/sparkle/appcast.xml"
    strategy :sparkle, &:short_version
  end

  no_autobump! because: :requires_manual_review

  auto_updates true

  app "Iconizer.app"

  zap trash: "~/Library/Preferences/com.raphaelhanneken.iconizer.plist"
end