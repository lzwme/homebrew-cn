cask "disk-expert" do
  version "5.2,536"
  sha256 "091277786d4587321d950b646759395d4135d0786f95db693b4e8d3600c6242e"

  url "https://download.nektony.com/download/diskexpert/disk-space-analyzer.dmg?build=#{version.csv.second}"
  name "Disk Expert"
  desc "Disk space analyzer"
  homepage "https://nektony.com/disk-expert"

  livecheck do
    url "https://download.nektony.com/pro-support/v3/disk-expert/update/update.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Disk Expert #{version.major}.app"

  zap trash: [
    "~/Library/Application Scripts/com.nektony.Disk-Expert-SII*",
    "~/Library/Application Support/Disk-Expert-SII*",
    "~/Library/Caches/com.nektony.Disk-Expert-SII*",
    "~/Library/Cookies/com.nektony.Disk-Expert-SII.binarycookies",
    "~/Library/HTTPStorages/com.nektony.Disk-Expert-SII*",
    "~/Library/Preferences/com.nektony.Disk-Expert-SII*.plist",
    "~/Library/Saved Application State/com.nektony.Disk-Expert-SII*.savedState",
  ]
end