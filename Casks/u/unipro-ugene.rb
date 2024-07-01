cask "unipro-ugene" do
  version "50.0"
  sha256 "92dab8153848cb13a10ffb2fc8374f544b8790f43c28ef64c8fac4a30dd2f6db"

  url "https:github.comugeneuniprougenereleasesdownload#{version}ugene-#{version}-mac-x86-64.dmg",
      verified: "github.comugeneuniprougene"
  name "Ugene"
  desc "Free open-source cross-platform bioinformatics software"
  homepage "https:ugene.net"

  app "Unipro UGENE.app"

  zap trash: [
    "~LibraryPreferencescom.unipro.UGENE.plist",
    "~LibraryPreferencesnet.ugene.ugene.plist",
  ]

  caveats do
    requires_rosetta
  end
end