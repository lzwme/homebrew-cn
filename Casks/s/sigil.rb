cask "sigil" do
  arch arm: "arm64", intel: "x86_64"

  version "2.4.2"
  sha256 arm:   "5e03c9ad00b40cca2aadac88adb957a24a57be4c0ef088fea50c097e00f88d42",
         intel: "f1dc45ae6de8788d9fc9e9172020a3851d3185179588daf9b05322b8ab89ecb2"

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