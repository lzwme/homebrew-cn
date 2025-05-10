cask "unipro-ugene" do
  version "52.1"
  sha256 "ac20a2303466bbf328473b9edd02c45d31c7d9bb3bd7956045b3d6356e365967"

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