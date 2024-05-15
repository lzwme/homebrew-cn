cask "sysdig-inspect" do
  version "0.11.0"
  sha256 "a320c885076d17c9ab586272239666a2394e0c82e78f8a2ac455e492fe8cc766"

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