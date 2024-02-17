cask "sysdig-inspect" do
  version "0.9.0"
  sha256 "be0c56bd2eaa751b0babaf5f8947b57bd278ed2447caab9e75634606cb3465e3"

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