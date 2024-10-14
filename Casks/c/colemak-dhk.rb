cask "colemak-dhk" do
  version "2.0.0"
  sha256 :no_check

  url "https:github.comColemakModsmod-dharchiverefsheadsmaster.tar.gz",
      verified: "github.comColemakModsmod-dh"
  name "Colemak-DHk Keyboard Layout"
  desc "Colemak mod for more comfortable typing (DHk variant)"
  homepage "https:colemakmods.github.iomod-dh"

  livecheck do
    url "https:raw.githubusercontent.comColemakModsmod-dhmastermacOSColemak%20DHk.bundleContentsInfo.plist"
    strategy :xml do |xml|
      xml.elements["key[text()='CFBundleVersion']"]&.next_element&.text&.strip
    end
  end

  keyboard_layout "mod-dh-mastermacOSColemak DHk.bundle"

  # No zap stanza required

  caveats do
    logout
  end
end