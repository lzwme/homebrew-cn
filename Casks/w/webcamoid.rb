cask "webcamoid" do
  version "9.0.0"
  sha256 "420f695e5bafbc1b9760ee5fb9bb06707cb302ff973975374ce7d857093c85dd"

  url "https:github.comwebcamoidwebcamoidreleasesdownload#{version}webcamoid-portable-mac-#{version}-x86_64.dmg",
      verified: "github.comwebcamoidwebcamoid"
  name "Webcamoid"
  desc "Webcam suite"
  homepage "https:webcamoid.github.io"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Webcamoid.app"

  uninstall launchctl: "org.webcamoid.cmio.AkVCam.Assistant",
            quit:      "com.webcamoidprj.webcamoid",
            delete:    "LibraryCoreMediaIOPlug-InsDALAkVirtualCamera.plugin"

  zap trash: [
    "~LibraryApplication SupportCrashReporterwebcamoid_*.plist",
    "~LibraryCachesWebcamoid",
    "~LibraryLaunchAgentsorg.webcamoid.cmio.AkVCam.Assistant.plist",
    "~LibraryLogsDiagnosticReportswebcamoid_*.crash",
    "~LibraryPreferencescom.webcamoid.PluginsCache.plist",
    "~LibraryPreferencescom.webcamoid.Webcamoid.plist",
    "~LibraryPreferencescom.webcamoidprj.webcamoid.plist",
    "~LibraryPreferencesorg.webcamoid.cmio.AkVCam.Assistant.plist",
    "~LibrarySaved Application Statecom.webcamoidprj.webcamoid.savedState",
  ]
end