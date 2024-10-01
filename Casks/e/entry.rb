cask "entry" do
  version "2.1.19"
  sha256 "78a76aa78c11e41c7b307f48c1e5b9b31bf35f7df4dde24855b6a046fe01faf6"

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