cask "xaos" do
  version "4.3.2"
  sha256 "4ab541bef66ab5d8d1a1ddc0cec41cedf5d09064e8f0ec4c6afcd2650956fbf0"

  url "https:github.comxaos-projectXaoSreleasesdownloadrelease-#{version}XaoS-#{version}.dmg",
      verified: "github.comxaos-projectXaoS"
  name "GNU XaoS"
  desc "Real-time interactive fractal zoomer"
  homepage "https:xaos-project.github.io"

  livecheck do
    url :url
    regex(^release[._-]v?(\d+(?:\.\d+)+)$i)
  end

  depends_on macos: ">= :big_sur"

  app "XaoS.app"

  caveats do
    requires_rosetta
  end
end