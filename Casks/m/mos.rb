cask "mos" do
  version "3.5.0"
  sha256 "a361f871f32e763a101df29e57839188ef7fb33a289853f420fe83e9e70c008e"

  url "https:github.comCaldisMosreleasesdownload#{version}Mos.Versions.#{version}.dmg",
      verified: "github.comCaldisMos"
  name "Mos"
  desc "Smooths scrolling and set mouse scroll directions independently"
  homepage "https:mos.caldis.me"

  app "Mos.app"

  zap trash: "~LibraryPreferencescom.caldis.Mos.plist"
end