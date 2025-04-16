cask "pyfa" do
  version "2.62.3"
  sha256 "3f75b4b1361a09ffacf7e51ead98749d5fa7b5af4e1a04a6d0ca7a21f40d5718"

  url "https:github.compyfa-orgPyfareleasesdownloadv#{version}pyfa-v#{version}-mac.zip"
  name "pyfa"
  desc "Fitting tool for EVE Online"
  homepage "https:github.compyfa-orgPyfa"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "pyfa.app"

  zap trash: [
    "~LibraryCachesorg.pyfaorg.pyfa",
    "~LibraryPreferencesorg.pyfaorg.pyfa.plist",
    "~LibrarySaved Application Stateorg.pyfaorg.pyfa.savedState",
  ]

  caveats do
    requires_rosetta
  end
end