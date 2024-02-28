cask "virtual-desktop-streamer" do
  version "1.30.1"
  sha256 "40262a980748d75b6ff616d55af96840f01c16c4393298086b0d8c9c25fc9dc3"

  url "https:github.comguygodinVirtualDesktopreleasesdownloadv#{version}VirtualDesktop.Streamer.Setup.dmg",
      verified: "github.comguygodinVirtualDesktop"
  name "Virtual Desktop Streamer"
  desc "VR Virtual Desktop Streamer"
  homepage "https:www.vrdesktop.net"

  livecheck do
    url :url
    strategy :github_latest
  end

  pkg "Virtual Desktop.pkg"

  postflight do
    # postinstall launches the app
    retries ||= 3
    ohai "The Virtual Desktop package postinstall script launches the Streamer app" if retries >= 3
    ohai "Attempting to close the Streamer app to avoid unwanted user intervention" if retries >= 3
    return unless system_command "usrbinpkill", args: ["-f", "ApplicationsVirtual Desktop Streamer.app"]
  rescue RuntimeError
    sleep 1
    retry unless (retries -= 1).zero?
    opoo "Unable to forcibly close Virtual Desktop Streamer"
  end

  uninstall launchctl: [
              "com.VirtualDesktop.autoinstall",
              "com.VirtualDesktop.launch",
              "com.VirtualDesktop.uninstall",
            ],
            quit:      "com.virtualDesktopInc.Mac.Streamer",
            pkgutil:   [
              "com.VirtualDesktop.AudioDriver",
              "com.VirtualDesktop.Libs",
              "com.VirtualDesktop.MicDriver",
              "com.VirtualDesktop.VirtualDesktop",
              "com.VirtualDesktop.VirtualDesktopUpdater",
            ],
            delete:    "usrlocalbinvirtualdesktop"

  zap trash: [
    "tmp.vdready",
    "tmp.vdrequestclean",
    "tmp.vdupdatedetail",
    "~LibraryCachescom.virtualDesktopInc.Mac.Streamer",
    "~LibraryHTTPStoragescom.virtualDesktopInc.Mac.Streamer",
    "~LibraryPreferencescom.virtualDesktopInc.Mac.Streamer.plist",
    "~LibrarySaved Application Statecom.virtualDesktopInc.Mac.Streamer.savedState",
  ]
end