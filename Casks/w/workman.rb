cask "workman" do
  version "1.0"
  sha256 :no_check

  url "https:github.comworkman-layoutWorkmanarchivemaster.zip",
      verified: "github.comworkman-layoutWorkman"
  name "Workman keyboard layout"
  desc "Alternative English keyboard layout"
  homepage "https:workmanlayout.org"

  livecheck do
    url :url
    strategy :extract_plist
  end

  keyboard_layout "Workman-mastermacWorkman.bundle"

  # No zap stanza required

  caveats do
    reboot
  end
end