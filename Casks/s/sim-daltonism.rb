cask "sim-daltonism" do
  version "2.0.5"
  sha256 "f094aa0fbcd7b9b29c4a0af34f1e6b4789467946d3b1eadcacb1085fccb6da72"

  url "https://littoral.michelf.ca/apps/sim-daltonism/sim-daltonism-#{version}.zip"
  name "Sim Daltonism"
  desc "Colour blindness simulator for videos and images"
  homepage "https://michelf.ca/projects/mac/sim-daltonism/"

  livecheck do
    url "https://littoral.michelf.ca/apps/sim-daltonism/"
    regex(/href=.*?sim-daltonism-(\d+(?:\.\d+)*)\.zip/i)
  end

  no_autobump! because: :requires_manual_review

  app "Sim Daltonism.app"

  zap trash: [
    "~/Library/Application Scripts/com.michelf.sim-daltonism",
    "~/Library/Containers/com.michelf.sim-daltonism",
  ]

  caveats do
    requires_rosetta
  end
end