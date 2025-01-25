cask "unipro-ugene" do
  version "52.0"
  sha256 "51015a1bb9d1de617d157842ab781ead8992999469c23b0bd43dc6a1fb427a72"

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