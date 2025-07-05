cask "eurkey" do
  version "1.2"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/jonasdiemer/EurKEY-Mac/archive/refs/heads/master.tar.gz",
      verified: "github.com/jonasdiemer/EurKEY-Mac/"
  name "EurKEY keyboard layout"
  desc "Keyboard Layout for Europeans, Coders and Translators"
  homepage "https://eurkey.steffen.bruentjen.eu/"

  livecheck do
    url "https://ghfast.top/https://raw.githubusercontent.com/jonasdiemer/EurKEY-Mac/master/EurKEY.keylayout"
    regex(/EurKEY\s+v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  keyboard_layout "EurKEY-Mac-master/EurKEY.icns"
  keyboard_layout "EurKEY-Mac-master/EurKEY.keylayout"

  # No zap stanza required

  caveats do
    reboot
  end
end