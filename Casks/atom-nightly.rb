cask "atom-nightly" do
  version "1.63.0-nightly1"
  sha256 "50d34ac7d66627749f509df7535078372c9e4e8ce2e82b70de2870147933457f"

  url "https:atom-installer.github.comv#{version}atom-mac.zip",
      verified: "atom-installer.github.com"
  name "Github Atom Nightly"
  desc "Cross-platform text editor"
  homepage "https:atom.ionightly"

  deprecate! date: "2023-12-17", because: :discontinued

  app "Atom Nightly.app"
  binary "#{appdir}Atom Nightly.appContentsResourcesappapmbinapm", target: "apm-nightly"
  binary "#{appdir}Atom Nightly.appContentsResourcesappatom.sh", target: "atom-nightly"

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