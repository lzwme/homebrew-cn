cask "gyroflow" do
  version "1.6.0"
  sha256 "7eb5364849b3a5798a40e6b979fa6ebeb3f3301c0970c6997e92d9a79bfb5b65"

  url "https:github.comgyroflowgyroflowreleasesdownloadv#{version}Gyroflow-mac-universal.dmg",
      verified: "github.comgyroflowgyroflow"
  name "Gyroflow"
  desc "Video stabilization using gyroscope data"
  homepage "https:gyroflow.xyz"

  depends_on macos: ">= :mojave"

  app "Gyroflow.app"

  zap trash: "~LibraryCachesGyroflow"
end