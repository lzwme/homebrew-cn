cask "servo" do
  version "2025-06-14"
  sha256 "05e8f1a36727a2f9e4964b11318c5bc9d986e94d48e4ac5f0c2107661db459ef"

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