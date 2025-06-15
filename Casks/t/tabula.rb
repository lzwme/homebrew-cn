cask "tabula" do
  version "1.2.1"
  sha256 "7f0270ce3db17cfa14a8a111de9fbf39fbdd330d9784796daf13019d08cac140"

  url "https:github.comtabulapdftabulareleasesdownloadv#{version.major_minor_patch}tabula-mac-#{version}.zip",
      verified: "github.comtabulapdftabula"
  name "Tabula"
  desc "Tool for liberating data tables trapped inside PDF files"
  homepage "https:tabula.technology"

  no_autobump! because: :requires_manual_review

  app "tabulaTabula.app"

  zap trash: [
    "~LibraryApplication SupportTabula",
    "~LibrarySaved Application Stateorg.nerdpower.tabula.Tabula.savedState",
  ]

  caveats do
    requires_rosetta
  end
end