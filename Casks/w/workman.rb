cask "workman" do
  version "1.0"
  sha256 :no_check

  url "https:github.comworkman-layoutWorkmanarchiverefsheadsmaster.tar.gz",
      verified: "github.comworkman-layoutWorkman"
  name "Workman keyboard layout"
  desc "Alternative English keyboard layout"
  homepage "https:workmanlayout.org"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-06-21", because: :unmaintained

  keyboard_layout "Workman-mastermacWorkman.bundle"

  # No zap stanza required

  caveats do
    reboot
  end
end