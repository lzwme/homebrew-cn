cask "bootxchanger" do
  version "2.0"
  sha256 "cfb05680ab6a7d0b1793a33135dd15562a7b5fd59bb1ebf3ad6067c2c9fad6c1"

  url "https:github.comzydecobootxchangerreleasesdownloadv#{version}bootxchanger_#{version}.dmg",
      verified: "github.comzydecobootxchanger"
  name "BootXChanger"
  desc "Utility to change the boot logo on old Macs"
  homepage "https:namedfork.netbootxchanger"

  deprecate! date: "2023-12-17", because: :discontinued

  app "BootXChanger.app"
end