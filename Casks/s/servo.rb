cask "servo" do
  version "2025-03-04"
  sha256 "b395f62de93e4647d882d04a35339eeeaf48444e995eed953f2b987acb702f73"

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