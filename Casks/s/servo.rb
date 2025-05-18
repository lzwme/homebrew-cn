cask "servo" do
  version "2025-05-17"
  sha256 "463d2bf6d40dbf4fa0dba06f4644953a75f8ac2f0d97589b9146677f2b606b4d"

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