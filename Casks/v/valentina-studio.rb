cask "valentina-studio" do
  version "15.1"
  sha256 "0e6965266ad97760a47b5ef70e768c409ba3dd9e2e24a40200468e68973e2c98"

  url "https://valentina-db.com/download/prev_releases/#{version}/mac_64/vstudio_x64_#{version.major}_mac.dmg"
  name "Valentina Studio"
  desc "Visual editors for data"
  homepage "https://valentina-db.com/en/valentina-studio-overview"

  livecheck do
    url "https://valentina-db.com/en/all-downloads/vstudio"
    regex(%r{href=['"]?/en/all-downloads/vstudio/current['"]?>\s*(\d+(?:\.\d+)+)}i)
  end

  depends_on macos: ">= :mojave"

  app "Valentina Studio.app"

  zap trash: [
    "~/Library/Logs/Valentina Studio",
    "~/Library/Preferences/com.paradigma-software-inc.Valentina Studio_ling.plist",
    "~/Library/Preferences/com.paradigmasoft.VStudio",
    "~/Library/Preferences/com.paradigmasoft.vstudio.plist",
    "~/Library/Saved Application State/com.paradigmasoft.vstudio.savedState",
  ]
end