cask "entry" do
  version "2.1.17"
  sha256 "5c29fdd4cf07e7dcd9da213f7ccf2ee8eee53891b6a1791c3ec104f2be7d312a"

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