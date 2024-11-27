cask "pyfa" do
  version "2.61.1"
  sha256 "8ae1df8adbc78ebef3e8ab9a154fae81f45b69b6759fb62c7356940c36006139"

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