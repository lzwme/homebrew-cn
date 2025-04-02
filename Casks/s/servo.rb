cask "servo" do
  version "2025-04-01"
  sha256 "8c744a8a917b422e10468d6965c65194aeadbe593ab025f080cc618bf16a4e33"

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