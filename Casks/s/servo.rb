cask "servo" do
  version "2025-03-17"
  sha256 "0a192585b3df19046d394379d60fabb30dfa41a21c848212d1d9f03cb3b4486d"

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