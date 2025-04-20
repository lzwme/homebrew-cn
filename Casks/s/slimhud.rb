cask "slimhud" do
  version "1.5.2"
  sha256 "c811e08478f33c09dad290fc070a849159f6ddc57f003034f442b524bedca3c2"

  url "https:github.comAlexPerathonerSlimHUDreleasesdownloadv#{version}SlimHUD.zip"
  name "SlimHUD"
  desc "Replacement for the volume, brightness and keyboard backlight HUDs"
  homepage "https:github.comAlexPerathonerSlimHUD"

  livecheck do
    url "https:alexperathoner.github.ioSlimHUDSupportappcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "SlimHUD.app"

  zap trash: "~LibraryPreferencescom.alexpera.SlimHUD.plist"
end