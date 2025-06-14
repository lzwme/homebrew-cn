cask "eurkey" do
  version "1.2"
  sha256 :no_check

  url "https:github.comjonasdiemerEurKEY-Macarchiverefsheadsmaster.tar.gz",
      verified: "github.comjonasdiemerEurKEY-Mac"
  name "EurKEY keyboard layout"
  desc "Keyboard Layout for Europeans, Coders and Translators"
  homepage "https:eurkey.steffen.bruentjen.eu"

  livecheck do
    url "https:raw.githubusercontent.comjonasdiemerEurKEY-MacmasterEurKEY.keylayout"
    regex(EurKEY\s+v?(\d+(?:\.\d+)+)i)
  end

  no_autobump! because: :requires_manual_review

  keyboard_layout "EurKEY-Mac-masterEurKEY.icns"
  keyboard_layout "EurKEY-Mac-masterEurKEY.keylayout"

  # No zap stanza required

  caveats do
    reboot
  end
end