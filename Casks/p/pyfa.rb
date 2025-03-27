cask "pyfa" do
  version "2.62.2"
  sha256 "b0619d808c9cac8be1224054ae8eb4ce7a65f0f36eb99184b3adc558476ae457"

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