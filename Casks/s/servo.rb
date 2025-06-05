cask "servo" do
  version "2025-06-04"
  sha256 "545bfd11054171d84e975724b4d382551a135bfe4502b56264b6394e83a6f14f"

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