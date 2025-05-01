cask "servo" do
  version "2025-04-30"
  sha256 "1dccc67a9e651df8f14703cb1e2ac1e9992c6e2ad8e5a3caeebfe67c7ec780fa"

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