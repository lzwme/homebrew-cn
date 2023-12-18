cask "xournal-plus-plus" do
  version "1.2.2"
  sha256 "847e3b85fa6123bc94db82a1f4eb0749778b82ac33432b3b25de3819f28dfcae"

  url "https:github.comxournalppxournalppreleasesdownloadv#{version}xournalpp-#{version}-macos.zip"
  name "Xournal++"
  desc "Handwriting notetaking software"
  homepage "https:github.comxournalppxournalpp"

  depends_on macos: ">= :catalina"

  app "Xournal++.app"

  zap trash: [
    "~LibrarySaved Application Statecom.github.xournalpp.savedState",
    "~.xournalpp",
  ]
end