cask "iconizer" do
  version "2020.11.0"
  sha256 "abaffdea473f4d3cd7d763fcb3846fbb752b87949e6ef7d273a95b6f5c5c1e06"

  url "https:github.comraphaelhannekeniconizerreleasesdownload#{version}Iconizer.dmg",
      verified: "github.comraphaelhannekeniconizer"
  name "Iconizer"
  desc "Xcode asset catalog creator"
  homepage "https:raphaelhanneken.comiconizer"

  livecheck do
    url "https:raphaelhanneken.github.ioiconizersparkleappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true

  app "Iconizer.app"

  zap trash: "~LibraryPreferencescom.raphaelhanneken.iconizer.plist"
end