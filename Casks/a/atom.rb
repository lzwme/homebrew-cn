cask "atom" do
  version "1.60.0"
  sha256 "dc5271b496c995b8ef957f4a53c3224771002715d15917c776fddb7d4a03b2c5"

  url "https:github.comatomatomreleasesdownloadv#{version}atom-mac.zip",
      verified: "github.comatomatom"
  name "GitHub Atom"
  desc "Text editor"
  homepage "https:atom.io"

  deprecate! date: "2023-12-17", because: :discontinued
  disable! date: "2024-12-21", because: :discontinued

  auto_updates true

  app "Atom.app"
  binary "#{appdir}Atom.appContentsResourcesappapmbinapm"
  binary "#{appdir}Atom.appContentsResourcesappatom.sh", target: "atom"

  zap trash: [
    "~.atom",
    "~LibraryApplication SupportAtom",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.github.atom.sfl*",
    "~LibraryApplication Supportcom.github.atom.ShipIt",
    "~LibraryApplication SupportShipIt_stderr.log",
    "~LibraryApplication SupportShipIt_stdout.log",
    "~LibraryCachescom.github.atom",
    "~LibraryCachescom.github.atom.ShipIt",
    "~LibraryLogsAtom",
    "~LibraryPreferencesByHostcom.github.atom.ShipIt.*.plist",
    "~LibraryPreferencescom.github.atom.helper.plist",
    "~LibraryPreferencescom.github.atom.plist",
    "~LibrarySaved Application Statecom.github.atom.savedState",
    "~LibraryWebKitcom.github.atom",
  ]

  caveats do
    requires_rosetta
  end
end