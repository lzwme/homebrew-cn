cask "disk-arbitrator" do
  version "0.8.0"
  sha256 "4dd2467c4a3a896ae0267087fe11df7bfc9d98c9f1bc049f401b58a59fca8533"

  url "https://ghfast.top/https://github.com/aburgh/Disk-Arbitrator/releases/download/v#{version}/Disk.Arbitrator-#{version.major_minor}.dmg"
  name "Disk Arbitrator"
  homepage "https://github.com/aburgh/Disk-Arbitrator"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-09", because: :unmaintained
  disable! date: "2025-07-09", because: :unmaintained

  app "Disk Arbitrator.app"

  uninstall launchctl: "us.burghardt.Disk-Arbitrator",
            quit:      "us.burghardt.Disk-Arbitrator"

  zap trash: "~/Library/Preferences/us.burghardt.Disk-Arbitrator.plist"

  caveats do
    requires_rosetta
  end
end