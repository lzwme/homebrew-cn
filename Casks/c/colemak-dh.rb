cask "colemak-dh" do
  version "2.0.0"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/ColemakMods/mod-dh/archive/refs/heads/master.tar.gz",
      verified: "github.com/ColemakMods/mod-dh/"
  name "Colemak-DH Keyboard Layout"
  desc "Colemak mod for more comfortable typing (DH variant)"
  homepage "https://colemakmods.github.io/mod-dh/"

  livecheck do
    url "https://ghfast.top/https://raw.githubusercontent.com/ColemakMods/mod-dh/master/macOS/Colemak%20DH.bundle/Contents/Info.plist"
    strategy :xml do |xml|
      version = xml.elements["//key[text()='CFBundleVersion']"]&.next_element&.text
      next if version.blank?

      version.strip
    end
  end

  no_autobump! because: :requires_manual_review

  keyboard_layout "mod-dh-master/macOS/Colemak DH.bundle"

  # No zap stanza required

  caveats do
    logout
  end
end