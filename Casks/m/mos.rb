cask "mos" do
  version "3.4.1"
  sha256 "38ea33e867815506414323484147b882b6d97df4af9759bca0a64d98c95029b3"

  url "https:github.comCaldisMosreleasesdownload#{version}Mos.Versions.#{version}.dmg",
      verified: "github.comCaldisMos"
  name "Mos"
  desc "Smooths scrolling and set mouse scroll directions independently"
  homepage "https:mos.caldis.me"

  app "Mos.app"

  zap trash: "~LibraryPreferencescom.caldis.Mos.plist"
end