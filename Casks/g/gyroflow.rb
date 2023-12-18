cask "gyroflow" do
  version "1.5.4"
  sha256 "ae2034c9b165c8596696b9f4e322ca297e6dfd0431e783528ef6a3288201e569"

  url "https:github.comgyroflowgyroflowreleasesdownloadv#{version}Gyroflow-mac-universal.dmg",
      verified: "github.comgyroflowgyroflow"
  name "Gyroflow"
  desc "Video stabilization using gyroscope data"
  homepage "https:gyroflow.xyz"

  depends_on macos: ">= :mojave"

  app "Gyroflow.app"

  zap trash: "~LibraryCachesGyroflow"
end