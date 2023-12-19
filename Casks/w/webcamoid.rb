cask "webcamoid" do
  version "9.0.0"
  sha256 "420f695e5bafbc1b9760ee5fb9bb06707cb302ff973975374ce7d857093c85dd"

  url "https:github.comwebcamoidwebcamoidreleasesdownload#{version}webcamoid-portable-mac-#{version}-x86_64.dmg",
      verified: "github.comwebcamoidwebcamoid"
  name "Webcamoid"
  desc "Webcam suite"
  homepage "https:webcamoid.github.io"

  deprecate! date: "2023-12-17", because: :discontinued

  app "Webcamoid.app"

  uninstall quit:      "com.webcamoidprj.webcamoid",
            launchctl: "org.webcamoid.cmio.AkVCam.Assistant",
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