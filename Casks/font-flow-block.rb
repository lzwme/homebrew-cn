cask "font-flow-block" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflflowblockFlowBlock-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Flow Block"
  homepage "https:fonts.google.comspecimenFlow+Block"

  font "FlowBlock-Regular.ttf"

  # No zap stanza required
end