cask "sysdig-inspect" do
  version "0.12.0"
  sha256 "392ab84b409b3522addf1197917d196003dcb821f014e57f57daa74a0424ed92"

  url "https:github.comdraiossysdig-inspectreleasesdownload#{version}sysdig-inspect-mac-x86_64.zip"
  name "Sysdig Inspect"
  desc "Interface for container troubleshooting and security investigation"
  homepage "https:github.comdraiossysdig-inspect"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "Sysdig Inspect-darwin-x64Sysdig Inspect.app"

  zap trash: [
    "~LibraryApplication Supportsysdig-inspect",
    "~LibraryLogsSysdig Inspect",
    "~LibraryPreferencescom.electron.sysdig-inspect.plist",
    "~LibrarySaved Application Statecom.electron.sysdig-inspect.savedState",
  ]

  caveats do
    requires_rosetta
  end
end