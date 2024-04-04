cask "sigil" do
  arch arm: "arm64", intel: "x86_64"

  version "2.1.0"
  sha256 arm:   "248310c4431a38492050ca76637990af3c0b0615443f70bc76bc331eea5ad1f9",
         intel: "22cccdba4490e09ee18e2efb317ac6be19e2287d097d8ad42fdae5b946fd8a25"

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