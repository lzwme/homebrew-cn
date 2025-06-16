cask "font-cica" do
  version "5.0.3"
  sha256 "cbd1bcf1f3fd1ddbffe444369c76e42529add8538b25aeb75ab682d398b0506f"

  url "https:github.commiitonCicareleasesdownloadv#{version}Cica_v#{version}.zip"
  name "Cica"
  homepage "https:github.commiitonCica"

  no_autobump! because: :requires_manual_review

  font "Cica-Bold.ttf"
  font "Cica-BoldItalic.ttf"
  font "Cica-Regular.ttf"
  font "Cica-RegularItalic.ttf"

  # No zap stanza required
end