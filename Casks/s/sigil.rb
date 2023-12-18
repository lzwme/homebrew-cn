cask "sigil" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.2"
  sha256 arm:   "bd7f5586974ed10334e11e53b71df5c2457b76445b8b3a30ae6fc664b4938030",
         intel: "ae3783f8a9c4dc5e0635e68fbc484e92dfb4969135594ab19ba3eddac0706007"

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