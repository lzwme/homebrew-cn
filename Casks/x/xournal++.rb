cask "xournal++" do
  arch arm: "ARM64", intel: "X64"

  version "1.2.6"
  sha256 arm:   "ebff35fae469be8542b7c57b2f14f8e0cf682fc8a88481f87012587626e127fd",
         intel: "703bac0e07f0c497d2958124d68b022cf393c200360acecb1c04ab2de0c7ca90"

  url "https:github.comxournalppxournalppreleasesdownloadv#{version}xournalpp-#{version}-macOS-#{arch}.dmg"
  name "Xournal++"
  desc "Handwriting notetaking software"
  homepage "https:github.comxournalppxournalpp"

  depends_on macos: ">= :catalina"

  app "Xournal++.app"

  zap trash: [
    "~.xournalpp",
    "~LibrarySaved Application Statecom.github.xournalpp.savedState",
  ]
end