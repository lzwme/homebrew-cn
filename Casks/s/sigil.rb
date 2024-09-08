cask "sigil" do
  arch arm: "arm64", intel: "x86_64"

  version "2.3.1"
  sha256 arm:   "ea117e9d6491a1921469a0ebc274e0d646f14fc8cd059474759e3980b247dc2d",
         intel: "05422dbac0a00ebbf8360f782f2cda16a768a22abb25cc3a06fb418d1e471194"

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