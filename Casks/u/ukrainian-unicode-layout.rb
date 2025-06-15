cask "ukrainian-unicode-layout" do
  version "1.2.2"
  sha256 "f5159ebc4f8aad0efd454d9080f7cd705a2132d57f64c10abb3d5e50ba772ab5"

  url "https:github.comkorzhykmacOS-Ukrainian-Unicode-Layoutarchiverefstags#{version}.tar.gz"
  name "Ukrainian Unicode Layout"
  desc "Installer for Ukrainian Unicode layout"
  homepage "https:github.comkorzhykOSX-Ukrainian-Unicode-Layout"

  no_autobump! because: :requires_manual_review

  keyboard_layout "macOS-Ukrainian-Unicode-Layout-#{version}"

  # No zap stanza required

  caveats do
    reboot
  end
end