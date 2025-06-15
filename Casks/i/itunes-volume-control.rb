cask "itunes-volume-control" do
  version "1.7.7"
  sha256 "e2699f2cc1fc4578fa0fb59294d208030ad5a48fd457713df9fae95077df2707"

  url "https:raw.githubusercontent.comalberti42Volume-ControlmainReleasesVolumeControl-v#{version}.zip",
      verified: "raw.githubusercontent.comalberti42Volume-ControlmainReleases"
  name "iTunes Volume Control"
  desc "Control the volume of Apple Music and Spotify using keyboard volume keys"
  homepage "https:github.comalberti42Volume-Control"

  livecheck do
    url "https:raw.githubusercontent.comalberti42Volume-ControlmainReleasesVolumeControlCast.xml"
    strategy :sparkle, &:short_version
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :mojave"

  app "Volume Control.app"
end