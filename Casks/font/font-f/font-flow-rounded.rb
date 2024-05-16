cask "font-flow-rounded" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflflowroundedFlowRounded-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Flow Rounded"
  homepage "https:fonts.google.comspecimenFlow+Rounded"

  font "FlowRounded-Regular.ttf"

  # No zap stanza required
end