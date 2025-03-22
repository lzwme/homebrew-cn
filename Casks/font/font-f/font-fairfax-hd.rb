cask "font-fairfax-hd" do
  version "2025-03-20"
  sha256 "383c0b3a7584647b69f4b35982eba73f994e7e62faf98a15e0a99c2a1cd23873"

  url "https:github.comkreativekorpopen-relayreleasesdownload#{version}FairfaxHD.zip",
      verified: "github.comkreativekorpopen-relay"
  name "Fairfax HD"
  homepage "https:www.kreativekorp.comsoftwarefontsfairfaxhd"

  font "FairfaxHaxHD.ttf"
  font "FairfaxHD.ttf"
  font "FairfaxPonaHD.ttf"
  font "FairfaxPulaHD.ttf"
  font "FairfaxSMHD.ttf"

  # No zap stanza required
end