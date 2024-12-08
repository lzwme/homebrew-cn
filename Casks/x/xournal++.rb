cask "xournal++" do
  arch arm: "ARM64", intel: "X64"

  version "1.2.5"
  sha256 arm:   "993aec0ffde20c8dd8c731e7bc2216bfe7e6e6d80356bda0e6ea9bfbe0b97a46",
         intel: "d640c34d7792ce9ab706c7291686527eadaa9de36e71756c028168cdc6cc0766"

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