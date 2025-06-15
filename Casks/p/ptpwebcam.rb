cask "ptpwebcam" do
  version "1.3.2"
  sha256 "3945f3fdda5b438584b769ee5d2e99a4d7cf7869db348c24ee387f033c8f02cc"

  url "https:github.comdognotdogptpwebcamreleasesdownloadv#{version}PTP_Webcam-v#{version}.pkg",
      verified: "github.comdognotdogptpwebcam"
  name "PTP Webcam"
  desc "DSLR live view video plugin"
  homepage "https:ptpwebcam.org"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  no_autobump! because: :requires_manual_review

  pkg "PTP_Webcam-v#{version}.pkg"

  uninstall launchctl: [
              "org.ptpwebcam.PtpWebcamAgent",
              "org.ptpwebcam.PtpWebcamAssistant",
            ],
            pkgutil:   [
              "org.ptpwebcam.pkg.EnableChrome",
              "org.ptpwebcam.pkg.EnableSkype",
              "org.ptpwebcam.pkg.EnableTeams",
              "org.ptpwebcam.pkg.EnableZoom",
              "org.ptpwebcam.pkg.PTPWebcam",
              "org.ptpwebcam.pkg.RemoveEOSWebcam",
            ],
            delete:    [
              "LibraryCoreMediaIOPlug-insDALPTPWebcamDALPlugin.plugin",
              "LibraryLaunchDaemonsorg.ptpwebcam.PtpWebcamAssistant.plist",
            ]

  zap trash: [
    "~LibraryCachesorg.ptpwebcam.PtpWebcamAgent",
    "~LibraryHTTPStoragesorg.ptpwebcam.PtpWebcamAgent",
    "~LibraryPreferencesorg.ptpwebcam.PtpWebcamAgent.plist",
  ]
end