cask "font-adlam-display" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofladlamdisplayADLaMDisplay-Regular.ttf",
      verified: "github.comgooglefonts"
  name "ADLaM Display"
  homepage "https:fonts.google.comspecimenADLaM+Display"

  font "ADLaMDisplay-Regular.ttf"

  # No zap stanza required
end