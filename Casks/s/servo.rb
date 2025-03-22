cask "servo" do
  version "2025-03-21"
  sha256 "4634d3a42e679c824e52d7ed02afa9d9f6aac9a3a4ec7b7d7bb5ab5416c564f2"

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