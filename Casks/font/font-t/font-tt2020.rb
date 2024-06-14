cask "font-tt2020" do
  version "0.2.1"
  sha256 "050fa5c979557229242db4fad007e18941e8d64aab1d2ae96c9e99c44773fa5d"

  url "https:github.comctrlcctrlvTT2020archivev#{version}.zip"
  name "TT2020"
  homepage "https:github.comctrlcctrlvTT2020"

  font "TT2020-#{version}distTT2020Base-Italic.ttf"
  font "TT2020-#{version}distTT2020Base-Regular.ttf"
  font "TT2020-#{version}distTT2020StyleB-Italic.ttf"
  font "TT2020-#{version}distTT2020StyleB-Regular.ttf"
  font "TT2020-#{version}distTT2020StyleD-Italic.ttf"
  font "TT2020-#{version}distTT2020StyleD-Regular.ttf"
  font "TT2020-#{version}distTT2020StyleE-Italic.ttf"
  font "TT2020-#{version}distTT2020StyleE-Regular.ttf"
  font "TT2020-#{version}distTT2020StyleF-Regular.ttf"
  font "TT2020-#{version}distTT2020StyleG-Regular.ttf"

  # No zap stanza required
end