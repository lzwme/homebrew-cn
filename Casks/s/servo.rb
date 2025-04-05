cask "servo" do
  version "2025-04-04"
  sha256 "49cb83570ea243354b7db24f102dce1e91e021fb506eb509b8593dad04cf5e14"

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