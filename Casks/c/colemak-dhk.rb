cask "colemak-dhk" do
  version "1.0"
  sha256 :no_check

  url "https:github.comColemakModsmod-dharchiverefsheadsmaster.tar.gz",
      verified: "github.comColemakModsmod-dh"
  name "Colemak-DHk Keyboard Layout"
  desc "Colemak mod for more comfortable typing (DHk variant)"
  homepage "https:colemakmods.github.iomod-dh"

  keyboard_layout "mod-dh-mastermacOSColemak DHk.bundle"

  # No zap stanza required

  caveats do
    logout
  end
end