cask "unipro-ugene" do
  version "51.0"
  sha256 "7780a9e047723b83cd8fea91aeff474ca39711bb76c10ae9a84691d2918dda1b"

  url "https:github.comugeneuniprougenereleasesdownload#{version}ugene-#{version}-mac-x86-64.dmg",
      verified: "github.comugeneuniprougene"
  name "Ugene"
  desc "Free open-source cross-platform bioinformatics software"
  homepage "https:ugene.net"

  depends_on macos: ">= :high_sierra"

  app "Unipro UGENE.app"

  zap trash: [
    "~LibraryPreferencescom.unipro.UGENE.plist",
    "~LibraryPreferencesnet.ugene.ugene.plist",
  ]

  caveats do
    requires_rosetta
  end
end