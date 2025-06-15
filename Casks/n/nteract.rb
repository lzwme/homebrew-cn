cask "nteract" do
  version "0.28.0"
  sha256 "de65abe5ed76489217a9c29bcc177aa5b2ee2f0657cd017301af33280ca8a737"

  url "https:github.comnteractnteractreleasesdownloadv#{version}nteract-#{version}.dmg"
  name "nteract"
  desc "Interactive computing suite"
  homepage "https:github.comnteractnteract"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  auto_updates true

  app "nteract.app"

  uninstall delete: "usrlocalbinnteract"

  zap trash: [
    "~LibraryApplication SupportCachesnteract-updater",
    "~LibraryApplication Supportnteract",
    "~LibraryLogsnteract",
    "~LibraryPreferencesio.nteract.nteract.plist",
    "~LibrarySaved Application Stateio.nteract.nteract.savedState",
  ]

  caveats do
    requires_rosetta
  end
end