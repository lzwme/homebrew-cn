cask "sysdig-inspect" do
  version "0.10.1"
  sha256 "a1e0c370c171d2e2e97fe8cc1ef27cde3ee790ef2058c713ed70dd95755bb040"

  url "https:github.comdraiossysdig-inspectreleasesdownload#{version}sysdig-inspect-mac-x86_64.zip"
  name "Sysdig Inspect"
  desc "Interface for container troubleshooting and security investigation"
  homepage "https:github.comdraiossysdig-inspect"

  livecheck do
    url :url
    strategy :github_latest
  end

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