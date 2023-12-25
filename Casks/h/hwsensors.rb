cask "hwsensors" do
  version "6.26.1440"
  sha256 "1ea229bebb1cdfa3b6091cacfd7ab04da781cd6191db9ed08a73eb901aefa418"

  url "https:github.comkozlekekHWSensorsreleasesdownload#{version.major_minor}HWSensors.#{version}.pkg.zip"
  name "HWSensors"
  desc "Tool to access information from available hardware sensors"
  homepage "https:github.comkozlekekHWSensors"

  deprecate! date: "2023-12-17", because: :discontinued

  pkg "HWSensors.#{version}.pkg"

  uninstall quit:       "org.hwsensors.HWMonitor",
            login_item: "HWMonitor",
            pkgutil:    "org.hwsensors.HWMonitor"

  zap trash: [
    "~LibraryApplication SupportHWMonitor",
    "~LibraryPreferencesorg.hwsensors.HWMonitor.plist",
  ]
end