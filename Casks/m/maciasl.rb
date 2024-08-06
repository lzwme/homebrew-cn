cask "maciasl" do
  version "1.6.5"
  sha256 "67071f4e91167360e4881ed2532cf6cc3cdcc4850b1ccbcaf4e13f270465f878"

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