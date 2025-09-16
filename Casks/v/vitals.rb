cask "vitals" do
  version "0.9"
  sha256 "18206b666b7629bc56cf2154b001112a67cdf06222a03049ab0823d088180ed7"

  url "https://ghfast.top/https://github.com/hmarr/vitals/releases/download/v#{version}/vitals-v#{version}.zip"
  name "Vitals"
  desc "Tiny process monitor"
  homepage "https://github.com/hmarr/vitals/"

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Vitals.app"

  zap trash: [
    "~/Library/Application Scripts/com.hmarr.Vitals-LaunchAtLoginHelper",
    "~/Library/Containers/com.hmarr.Vitals-LaunchAtLoginHelper",
  ]
end