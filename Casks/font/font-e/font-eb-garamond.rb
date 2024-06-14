cask "font-eb-garamond" do
  version "0.016"
  sha256 "a0b77b405f55c10cff078787ef9d2389a9638e7604d53aa80207fe62e104c378"

  url "https:bitbucket.orggeorgdeb-garamonddownloadsEBGaramond-#{version}.zip",
      verified: "bitbucket.orggeorgdeb-garamond"
  name "EB Garamond"
  homepage "https:github.comgeorgdEB-Garamond"

  font "EBGaramond-#{version}otfEBGaramond-Initials.otf"
  font "EBGaramond-#{version}otfEBGaramond-InitialsF1.otf"
  font "EBGaramond-#{version}otfEBGaramond-InitialsF2.otf"
  font "EBGaramond-#{version}otfEBGaramond08-Italic.otf"
  font "EBGaramond-#{version}otfEBGaramond08-Regular.otf"
  font "EBGaramond-#{version}otfEBGaramond12-AllSC.otf"
  font "EBGaramond-#{version}otfEBGaramond12-Italic.otf"
  font "EBGaramond-#{version}otfEBGaramond12-Regular.otf"
  font "EBGaramond-#{version}otfEBGaramondSC08-Regular.otf"
  font "EBGaramond-#{version}otfEBGaramondSC12-Regular.otf"

  # No zap stanza required
end