cask "tikzit" do
  version "2.1.6"
  sha256 "4c7e2de7f021805272505b5313890ec4bcd42e2a66c2de7af74a866e5c96a3ed"

  url "https:github.comtikzittikzitreleasesdownloadv#{version}tikzit-osx.dmg",
      verified: "github.comtikzittikzit"
  name "TikZiT"
  desc "PGFTikZ diagram editor"
  homepage "https:tikzit.github.io"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "TikZiT.app"

  zap trash: [
    "~LibraryPreferencescom.tikzit.tikzit.plist",
    "~LibraryPreferencesio.github.tikzit.plist",
    "~LibrarySaved Application Stateio.github.tikzit.savedState",
  ]

  caveats do
    requires_rosetta
  end
end