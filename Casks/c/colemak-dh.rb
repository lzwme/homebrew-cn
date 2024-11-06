cask "colemak-dh" do
  version "2.0.0"
  sha256 :no_check

  url "https:github.comColemakModsmod-dharchiverefsheadsmaster.tar.gz",
      verified: "github.comColemakModsmod-dh"
  name "Colemak-DH Keyboard Layout"
  desc "Colemak mod for more comfortable typing (DH variant)"
  homepage "https:colemakmods.github.iomod-dh"

  livecheck do
    url "https:raw.githubusercontent.comColemakModsmod-dhmastermacOSColemak%20DH.bundleContentsInfo.plist"
    strategy :xml do |xml|
      version = xml.elements["key[text()='CFBundleVersion']"]&.next_element&.text
      next if version.blank?

      version.strip
    end
  end

  keyboard_layout "mod-dh-mastermacOSColemak DH.bundle"

  # No zap stanza required

  caveats do
    logout
  end
end