cask "servo" do
  version "2025-04-10"
  sha256 "0bba28d3da39c6f55a0cae26db072bf5c6cdd5b5840da6b363160bc531fdcbc4"

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