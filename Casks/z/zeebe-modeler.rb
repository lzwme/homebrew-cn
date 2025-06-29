cask "zeebe-modeler" do
  version "0.11.0"
  sha256 "6d0e08b53959d4c38afe193fdc3f3113c0f46403a55574f4359d23d1e1313891"

  url "https:github.comzeebe-iozeebe-modelerreleasesdownloadv#{version}zeebe-modeler-#{version}-mac.zip",
      verified: "github.comzeebe-iozeebe-modeler"
  name "Zeebe Modeler"
  desc "Desktop Application for modelling Zeebe Workflows with BPMN"
  homepage "https:zeebe.io"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Zeebe Modeler.app"
end