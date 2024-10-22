cask "xournal++" do
  version "1.2.4"
  sha256 "441f4b075548ae942a6a1217c958b2dcaa05575d0016c8cc27541358e8669c3a"

  url "https:github.comxournalppxournalppreleasesdownloadv#{version}xournalpp-#{version}-macos.zip"
  name "Xournal++"
  desc "Handwriting notetaking software"
  homepage "https:github.comxournalppxournalpp"

  depends_on macos: ">= :catalina"

  app "Xournal++.app"

  zap trash: [
    "~.xournalpp",
    "~LibrarySaved Application Statecom.github.xournalpp.savedState",
  ]

  caveats do
    requires_rosetta
  end
end