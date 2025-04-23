cask "servo" do
  version "2025-04-22"
  sha256 "e89b77649c881ca9d438a95cdda86f8a255c20b5bc0e0ca5ed339ba5d7bb23d1"

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