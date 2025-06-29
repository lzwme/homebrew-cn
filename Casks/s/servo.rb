cask "servo" do
  version "2025-06-28"
  sha256 "1076c7404be095780104f6578a92eb2ed0bc9e661042409b1c14998e6722a90d"

  url "https:github.comservoservo-nightly-buildsreleasesdownload#{version}servo-latest.dmg",
      verified: "github.comservoservo-nightly-builds"
  name "Servo"
  desc "Parallel browser engine"
  homepage "https:servo.org"

  livecheck do
    url :url
    regex(^v?(\d+(?:[.-]\d+)+)$i)
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "Servo.app"

  zap trash: "~LibraryApplication SupportServo"

  caveats do
    requires_rosetta
  end
end