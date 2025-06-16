cask "font-tt2020" do
  version "0.2.1"
  sha256 "a6c34a7ffce6e2f87c12566724029bde528364ce653805ac3d28a34845d815e7"

  url "https:github.comctrlcctrlvTT2020archiverefstagsv#{version}.tar.gz"
  name "TT2020"
  homepage "https:github.comctrlcctrlvTT2020"

  no_autobump! because: :requires_manual_review

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