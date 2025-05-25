cask "sigil" do
  arch arm: "arm64", intel: "x86_64"

  version "2.5.0"
  sha256 arm:   "92a65ba45a76dd0f468609b57d4f8983dcb169951bb97f0e9d0278d33e82b9f6",
         intel: "ea1011a4c2a3b1df7a8a208906530f482d09cf0bcba120e580531eeacaac53b6"

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