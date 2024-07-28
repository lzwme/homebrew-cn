cask "mymonero" do
  version "1.3.3"
  sha256 "39001378bdd5db86329b4b4bb70cdb876f632c82855ea53502f7824f9e114e05"

  url "https:github.commymoneromymonero-app-jsreleasesdownloadv#{version}MyMonero-#{version}.dmg",
      verified: "github.commymoneromymonero-app-js"
  name "MyMonero"
  desc "Wallet for the Monero cryptocurrency"
  homepage "https:mymonero.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "MyMonero.app"

  zap trash: [
    "~LibraryApplication SupportMyMonero",
    "~LibraryLogsMyMonero",
    "~LibraryPreferencescom.mymonero.mymonero-desktop.plist",
    "~LibrarySaved Application Statecom.mymonero.mymonero-desktop.savedState",
  ]

  caveats do
    requires_rosetta
  end
end