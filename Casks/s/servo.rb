cask "servo" do
  version "2025-06-01"
  sha256 "06667a74eac8d5c23ea94b20bfac04bb1159d39dc720001c4d7740a8eda84e08"

  url "https:github.comservoservo-nightly-buildsreleasesdownload#{version}servo-latest.dmg",
      verified: "github.comservoservo-nightly-builds"
  name "Servo"
  desc "Parallel browser engine"
  homepage "https:servo.org"

  depends_on macos: ">= :ventura"

  app "Servo.app"

  zap trash: "~LibraryApplication SupportServo"

  caveats do
    requires_rosetta
  end
end