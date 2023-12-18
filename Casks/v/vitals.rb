cask "vitals" do
  version "0.9"
  sha256 "18206b666b7629bc56cf2154b001112a67cdf06222a03049ab0823d088180ed7"

  url "https:github.comhmarrvitalsreleasesdownloadv#{version}vitals-v#{version}.zip"
  name "Vitals"
  desc "Tiny process monitor"
  homepage "https:github.comhmarrvitals"

  app "Vitals.app"

  zap trash: [
    "~LibraryApplication Scriptscom.hmarr.Vitals-LaunchAtLoginHelper",
    "~LibraryContainerscom.hmarr.Vitals-LaunchAtLoginHelper",
  ]
end