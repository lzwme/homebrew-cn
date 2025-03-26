cask "servo" do
  version "2025-03-25"
  sha256 "02326aef02886c0d48c005a371cacb903c8d9101a260d8cd47adba6fd8dd260f"

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