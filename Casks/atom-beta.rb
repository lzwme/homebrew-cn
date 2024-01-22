cask "atom-beta" do
  version "1.61.0-beta0"
  sha256 "9d96b0483ec121fd70b2d57b0d5d33cb5bc716faa38b1a90e78e3d41ab7ece11"

  url "https:github.comatomatomreleasesdownloadv#{version}atom-mac.zip",
      verified: "github.comatomatom"
  name "Github Atom Beta"
  desc "Cross-platform text editor"
  homepage "https:atom.iobeta"

  deprecate! date: "2023-12-17", because: :discontinued

  auto_updates true

  app "Atom Beta.app"
  binary "#{appdir}Atom Beta.appContentsResourcesappapmbinapm", target: "apm-beta"
  binary "#{appdir}Atom Beta.appContentsResourcesappatom.sh", target: "atom-beta"

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
    "~LibraryPreferencescom.github.atom.helper.plist",
    "~LibraryPreferencescom.github.atom.plist",
    "~LibrarySaved Application Statecom.github.atom.savedState",
  ]
end