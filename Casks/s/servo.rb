cask "servo" do
  version "2025-05-30"
  sha256 "30b9024b7c0c0eadabe465f8aaa8ec1e84aba220138b6bcb3e4f2e91dfd6aa7e"

  url "https:github.comservoservo-nightly-buildsreleasesdownload#{version}servo-latest.dmg",
      verified: "github.comservoservo-nightly-builds"
  name "Servo"
  desc "Parallel browser engine"
  homepage "https:servo.org"

  depends_on macos: ">= :ventura"

  app "Servo.app"

  zap trash: "~LibraryApplication SupportServo"

  caveats do
    requires_rosetta
  end
end