cask "sigil" do
  arch arm: "arm64", intel: "x86_64"

  version "2.2.0"
  sha256 arm:   "e8ca54668d7246c29908c39a96f295a0e64939d7595d577fa5e74c39edd6f171",
         intel: "5129bb97bffc9f84be4dcbd809b51f979bf91df0c30b5a8eab3c7e741495b040"

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