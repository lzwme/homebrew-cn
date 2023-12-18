cask "firebird-emu" do
  version "1.6"
  sha256 "c68aae5b077bd447845f476316fed93cf261ac7221fac0a38dfc0a575a3392d2"

  url "https:github.comnspire-emusfirebirdreleasesdownloadv#{version}firebird-emu_macOS.zip"
  name "firebird"
  desc "TI Nspire calculator emulator"
  homepage "https:github.comnspire-emusfirebird"

  app "firebird-emu.app"

  zap trash: "~LibraryPreferencesorg.firebird-emus.firebird-emu.plist"
end