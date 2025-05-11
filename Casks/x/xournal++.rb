cask "xournal++" do
  arch arm: "ARM64", intel: "X64"

  version "1.2.7"
  sha256 arm:   "8c5775dc04d21cfb968f3e52bf7043806e362d4a4828e36a902be3914f5c2c9b",
         intel: "9a6b7dcf1aa79fdbb6cf3ac8c44a2f8cb056be92fb368f123c181c6605607e3f"

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