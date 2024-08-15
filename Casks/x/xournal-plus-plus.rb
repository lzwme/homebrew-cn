cask "xournal-plus-plus" do
  version "1.2.3"
  sha256 "3fdd861352c1663c43d7a4cd30f0c2297f9d593acac23d311ecd63ec9a7cd231"

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