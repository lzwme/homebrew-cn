cask "sigil" do
  arch arm: "arm64", intel: "x86_64"

  version "2.5.2"
  sha256 arm:   "474a2ee7079504cec0a67545ec0c43e9778812a260af2d28e977bf55eefbe9c7",
         intel: "cbe208b53643d3770ff7f6ac6969938c34aedb51d7e659098d0ec059f30bccfe"

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