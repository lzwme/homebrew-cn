cask "maciasl" do
  version "1.6.4"
  sha256 "1a4885e9a1dbd66c38f68c5c471b2024f9e085db10bfbe0e7e1e5e32ed32790d"

  url "https:github.comacidantheraMaciASLreleasesdownload#{version}MaciASL-#{version}-RELEASE.dmg"
  name "MaciASL"
  desc "ACPI Machine Language (AML) compiler and IDE"
  homepage "https:github.comacidantheraMaciASL"

  auto_updates true

  app "MaciASL.app"
  binary "#{appdir}MaciASL.appContentsMacOSiasl-stable", target: "iasl"

  uninstall quit: "org.acidanthera.MaciASL"

  zap trash: [
    "~LibraryPreferencesorg.acidanthera.MaciASL.plist",
    "~LibrarySaved Application Stateorg.acidanthera.MaciASL.savedState",
  ]
end