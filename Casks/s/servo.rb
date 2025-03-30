cask "servo" do
  version "2025-03-29"
  sha256 "5fe4675efe9383d17535e3bffce8e31c2d089795da37532d19a4b9e7fc71771e"

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