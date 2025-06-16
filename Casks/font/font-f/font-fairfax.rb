cask "font-fairfax" do
  version "2025-03-20"
  sha256 "3060579c3853acd08d781c2c1c5479908d32652bb84646e10edd6435bc88628e"

  url "https:github.comkreativekorpopen-relayreleasesdownload#{version}Fairfax.zip",
      verified: "github.comkreativekorpopen-relay"
  name "Fairfax"
  homepage "https:www.kreativekorp.comsoftwarefontsfairfax"

  no_autobump! because: :requires_manual_review

  font "Fairfax.ttf"
  font "FairfaxBold.ttf"
  font "FairfaxHax.ttf"
  font "FairfaxHaxBold.ttf"
  font "FairfaxHaxItalic.ttf"
  font "FairfaxItalic.ttf"
  font "FairfaxPona.ttf"
  font "FairfaxPula.ttf"
  font "FairfaxSerif.ttf"
  font "FairfaxSerifHax.ttf"
  font "FairfaxSerifSM.ttf"
  font "FairfaxSM.ttf"
  font "FairfaxSMBold.ttf"
  font "FairfaxSMItalic.ttf"

  # No zap stanza required
end