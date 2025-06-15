cask "opencpn" do
  version "5.10.2,-universal+11049.12e5712b6-14"
  sha256 "680a79637b33799fec579d61546ac51b5533d7bcaf147466eed3e8327cc2cd82"

  url "https:github.comOpenCPNOpenCPNreleasesdownloadRelease_#{version.csv.first}OpenCPN_#{version.csv.first}#{version.csv.second}.pkg",
      verified: "github.comOpenCPNOpenCPN"
  name "OpenCPN"
  desc "Full-featured and concise ChartPlotterNavigator"
  homepage "https:www.opencpn.org"

  livecheck do
    url "https:www.opencpn.orgOpenCPNinfodownloadopencpn.html"
    regex(href=.*?OpenCPN[._-]?v?(\d+(?:\.+\d+)+)((?:-\d+)?(?:-universal)?\+\d+\.\h+(?:-\d+)?)?\.(?:dmg|pkg)i)
    strategy :page_match do |page, regex|
      match = page.match(regex)
      next if match.blank?

      match[2].present? ? "#{match[1]},#{match[2]}" : match[1]
    end
  end

  no_autobump! because: :requires_manual_review

  pkg "OpenCPN_#{version.csv.first}#{version.csv.second}.pkg"

  uninstall pkgutil: [
    "org.opencpn",
    "org.opencpn.pkg.OpenCPN",
  ]

  zap trash: [
    "~LibraryLogsopencpn.log",
    "~LibraryPreferencesopencpn",
    "~LibraryPreferencesorg.opencpn.plist",
    "~LibrarySaved Application Stateorg.opencpn.savedState",
  ]
end