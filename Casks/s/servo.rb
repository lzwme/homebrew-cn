cask "servo" do
  version "2025-05-13"
  sha256 "6bfdd774100d7811d4307d8ff0ecaee55c0059ca7d3d24f32281991b4792bc0b"

  url "https:github.comservoservo-nightly-buildsreleasesdownload#{version}servo-latest.dmg",
      verified: "github.comservoservo-nightly-builds"
  name "Servo"
  desc "Parallel browser engine"
  homepage "https:servo.org"

  depends_on macos: ">= :ventura"

  app "Servo.app"

  caveats do
    requires_rosetta
  end
end