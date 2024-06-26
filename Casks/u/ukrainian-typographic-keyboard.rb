cask "ukrainian-typographic-keyboard" do
  version "2.0.0"
  sha256 "6f4e4e6c3f68de73961b45864ece2a72156b2d9c23fcfa62ef5377e658150b1e"

  url "https:github.comdenysdovhanukrainian-typographic-keyboardarchiverefstagsv#{version}.tar.gz",
      verified: "github.comdenysdovhanukrainian-typographic-keyboard"
  name "Ukrainian Unicode Layout"
  desc "Combined Ukrainian keyboard layout with typographic symbols"
  homepage "https:denysdovhan.comukrainian-typographic-keyboard"

  keyboard_layout "ukrainian-typographic-keyboard-#{version}ukrainian-typographic-keyboard.bundle"

  # No zap stanza required

  caveats do
    reboot
  end
end