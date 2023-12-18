cask "metaz" do
  version "1.0.3"
  sha256 "0458c1fdcadc198aeca68e1d775195c3022b549f70c0483e57930731af913cbe"

  url "https:github.comgriffmetazreleasesdownloadv#{version}MetaZ-#{version}.zip",
      verified: "github.comgriffmetaz"
  name "MetaZ"
  desc "Mp4 meta-data editor"
  homepage "https:metaz.maven-group.org"

  livecheck do
    url :homepage
    regex(href=.*?MetaZ[._-]v?(.+)\.zipi)
  end

  app "MetaZ.app"

  zap trash: [
    "~LibraryCachesorg.maven-group.MetaZ",
    "~LibraryLogsMetaZ.log",
    "~LibraryPreferencesorg.maven-group.MetaZ.plist",
  ]
end