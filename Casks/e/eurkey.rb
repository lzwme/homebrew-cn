cask "eurkey" do
  version "1.2"
  sha256 :no_check

  url "https:github.comjonasdiemerEurKEY-Macarchivemaster.zip",
      verified: "github.comjonasdiemerEurKEY-Mac"
  name "EurKEY keyboard layout"
  desc "Keyboard Layout for Europeans, Coders and Translators"
  homepage "https:eurkey.steffen.bruentjen.eu"

  livecheck do
    url "https:raw.githubusercontent.comjonasdiemerEurKEY-MacmasterEurKEY.keylayout"
    regex(EurKEY\s+v?(\d+(?:\.\d+)+)i)
  end

  keyboard_layout "EurKEY-Mac-masterEurKEY.icns"
  keyboard_layout "EurKEY-Mac-masterEurKEY.keylayout"

  # No zap stanza required

  caveats do
    reboot
  end
end