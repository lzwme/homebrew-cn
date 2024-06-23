cask "sigil" do
  arch arm: "arm64", intel: "x86_64"

  version "2.2.1"
  sha256 arm:   "7bd49c6160553894ac5d9966688e7f799d21eabcb094359299f9735cd69b6a16",
         intel: "8989b6a7121e7fc1ebf50a3eb83fbd2e744db9e3d02670e5971c099a0c8c087f"

  url "https:github.comSigil-EbookSigilreleasesdownload#{version}Sigil.app-#{version}-Mac-#{arch}.txz",
      verified: "github.comSigil-EbookSigil"
  name "Sigil"
  desc "EPUB ebook editor"
  homepage "https:sigil-ebook.com"

  depends_on macos: ">= :sierra"

  app "Sigil.app"

  zap trash: [
    "~LibraryApplication Supportsigil-ebook",
    "~LibraryPreferencescom.sigil-ebook.Sigil.app.plist",
    "~LibrarySaved Application Statecom.sigil-ebook.Sigil.app.savedState",
  ]
end