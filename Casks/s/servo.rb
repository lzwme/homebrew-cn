cask "servo" do
  version "2025-03-10"
  sha256 "59788ef93cbcc74ca1d9a211391ee37d52c565394455208d9f65b1c0cd1f503c"

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