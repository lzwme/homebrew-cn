cask "servo" do
  version "2025-03-16"
  sha256 "59b616a8094617891cbf988dbd321378da013711c9bf1a13c701e4cc9ffdcfa4"

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