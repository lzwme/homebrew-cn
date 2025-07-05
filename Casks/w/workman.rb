cask "workman" do
  version "1.0"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/workman-layout/Workman/archive/refs/heads/master.tar.gz",
      verified: "github.com/workman-layout/Workman/"
  name "Workman keyboard layout"
  desc "Alternative English keyboard layout"
  homepage "https://workmanlayout.org/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-06-21", because: :unmaintained
  disable! date: "2025-06-21", because: :unmaintained

  keyboard_layout "Workman-master/mac/Workman.bundle"

  # No zap stanza required

  caveats do
    reboot
  end
end