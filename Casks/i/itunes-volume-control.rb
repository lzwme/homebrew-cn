cask "itunes-volume-control" do
  version "1.7.5"
  sha256 "0d4d22476e3a1b4891e335d86eb28c46fe663bd6d3226d3a8d0ad5d6a5de76d9"

  url "https:raw.githubusercontent.comalberti42Volume-ControlmainReleasesVolumeControl-v#{version}.zip",
      verified: "raw.githubusercontent.comalberti42Volume-ControlmainReleases"
  name "iTunes Volume Control"
  desc "Control the volume of Apple Music and Spotify using keyboard volume keys"
  homepage "https:github.comalberti42Volume-Control"

  # Upstream doesn't use GitHub releases or reliably create tags for new
  # versions. Instead, we match the file links in the README.
  livecheck do
    url "https:raw.githubusercontent.comalberti42Volume-ControlmainREADME.md"
    regex(VolumeControl[._-]v?(\d+(?:\.\d+)+)\.zipi)
  end

  auto_updates true
  depends_on macos: ">= :mojave"

  app "Volume Control.app"
end