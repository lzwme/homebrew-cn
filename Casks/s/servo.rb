cask "servo" do
  version "2025-03-24"
  sha256 "e816c13bfa74aeeb751554ae1072910bf27ea243e82f1ac43ec1c4a9239a84b4"

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