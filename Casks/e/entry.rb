cask "entry" do
  version "2.1.21"
  sha256 "216e255b5101706e43afeb3c7220f9ac890dc5d3b1ad9b79643e3c862dd6b37e"

  url "https:playentry.orguploadsdatainstallersEntry-#{version}.pkg"
  name "entry"
  desc "Block-based coding platform"
  homepage "https:playentry.org"

  # The download page (https:playentry.orgdownloadoffline) fetches the
  # version information from https:playentry.orggraphql using a `POST`
  # request but livecheck can't do that yet. We check GitHub releases as a best
  # guess of when a new version is released.
  livecheck do
    url "https:github.comentrylabsentry-offline"
    strategy :github_latest
  end

  pkg "Entry-#{version}.pkg"

  uninstall pkgutil: "org.playentry.entry"

  zap trash: [
    "~LibraryApplication SupportEntry",
    "~LibraryApplication Supportentry-hw",
    "~LibraryPreferencesorg.playentry.entry.plist",
    "~LibrarySaved Application Stateorg.playentry.entry.savedState",
  ]
end