cask "servo" do
  version "2025-03-08"
  sha256 "75f5b064560bd7081f721268ce0dcf297d7710f68c075788d273a0f4b36f920f"

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