cask "servo" do
  version "2025-03-26"
  sha256 "f83c516903ff6426065016012d049b5012a8e0ae5f153d577964b94fc5618b04"

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