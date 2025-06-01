cask "sigil" do
  arch arm: "arm64", intel: "x86_64"

  version "2.5.1"
  sha256 arm:   "48340b3590b46f8f97292695a8a797a502a78d84411af0a48796781296782701",
         intel: "379132b854e6fbfdeb302ab23507d836dc0e715560e9df7109891bae631325b3"

  url "https:github.comSigil-EbookSigilreleasesdownload#{version}Sigil.app-#{version}-Mac-#{arch}.txz",
      verified: "github.comSigil-EbookSigil"
  name "Sigil"
  desc "EPUB ebook editor"
  homepage "https:sigil-ebook.com"

  livecheck do
    url "https:raw.githubusercontent.comSigil-EbookSigilmasterversion.xml"
    strategy :xml do |xml|
      xml.elements["current-version"]&.text&.strip
    end
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Sigil.app"

  zap trash: [
    "~LibraryApplication Supportsigil-ebook",
    "~LibraryPreferencescom.sigil-ebook.Sigil.app.plist",
    "~LibrarySaved Application Statecom.sigil-ebook.Sigil.app.savedState",
  ]
end