cask "sensiblesidebuttons" do
  version "1.0.6"
  sha256 "1f2b3aefc47ac1ff8ce1e83af3ddab814dd7c6e6b974b73dce3694ec7435881b"

  url "https:github.comarchagonsensible-side-buttonsreleasesdownload#{version}SensibleSideButtons-#{version}.dmg",
      verified: "github.comarchagonsensible-side-buttons"
  name "Sensible Side Buttons"
  desc "Utilise mouse side navigation buttons"
  homepage "https:sensible-side-buttons.archagon.net"

  app "SensibleSideButtons.app"

  zap trash: "~LibraryPreferencesnet.archagon.sensible-side-buttons.plist"
end