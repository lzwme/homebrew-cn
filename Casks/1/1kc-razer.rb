cask "1kc-razer" do
  version "0.4.10"
  sha256 "9f57f928adb31ca843dbf2047a7d6ea308eceaccb50620792535d1fcd7ec73ca"

  url "https:github.com1kcrazer-macosreleasesdownloadv#{version}Razer.macOS-#{version}-universal.dmg"
  name "Razer macOS"
  desc "Open source colour effects manager for Razer devices"
  homepage "https:github.com1kcrazer-macos"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "Razer macOS.app"

  zap trash: [
    "~LibraryPreferencescom.electron.razer-macos.helper.Renderer.plist",
    "~LibraryPreferencescom.electron.razer-macos.plist",
    "~LibrarySaved Application Statecom.electron.razer-macos.savedState",
  ]
end