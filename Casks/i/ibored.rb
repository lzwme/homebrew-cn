cask "ibored" do
  version "1.2.1"
  sha256 "f20c11204eed840c62ab2256004baba813e3514d5e237a71dd696595e11303e3"

  url "https://files.tempel.org/iBored/iBored-Mac_#{version}.zip"
  name "iBored"
  desc "Hex editor"
  homepage "https://apps.tempel.org/iBored/"

  livecheck do
    url "https://apps.tempel.org/iBored/appcast.xml"
    strategy :sparkle
  end

  no_autobump! because: :requires_manual_review

  app "iBored.app"

  caveats do
    requires_rosetta
  end
end