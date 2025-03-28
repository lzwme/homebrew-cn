cask "servo" do
  version "2025-03-27"
  sha256 "1bc10cb2809ac031d9b16b1b316b131acb0336602b12c8564fe75a43ec00cce5"

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