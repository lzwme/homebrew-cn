cask "qwerty-fr" do
  version "0.7.1"
  sha256 "aa036941b3552df47c58e27fc5641835da3ab3df660c4092086a2ea75d36fa28"

  url "https:github.comqwerty-frqwerty-frreleasesdownloadv#{version}qwerty-fr_#{version}_mac.zip",
      verified: "github.comqwerty-frqwerty-fr"
  name "qwerty-fr keyboard layout"
  desc "QWERTY-based layout. Type EU languages, greek, math, currencies, & more!"
  homepage "https:qwerty-fr.org"

  livecheck do
    skip "Latest release only contains a hotfix for the Linux version"
  end

  depends_on macos: ">= :sierra"

  keyboard_layout "qwerty-fr.bundle"

  # No zap stanza required

  caveats do
    reboot
  end
end