cask "servo" do
  version "2025-04-25"
  sha256 "d3cf74e801c8f16ff80e47856b6bd853861f5183820769ca691cd7d3bf146411"

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