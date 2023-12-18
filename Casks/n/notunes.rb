cask "notunes" do
  version "3.4"
  sha256 "aecff4a11ba94c166978a9e59741bdcf25912ed232cb740efabbc4a097712028"

  url "https:github.comtomboneznoTunesreleasesdownloadv#{version}noTunes-#{version}.zip"
  name "noTunes"
  desc "Simple application that will prevent iTunes or Apple Music from launching"
  homepage "https:github.comtomboneznoTunes"

  app "noTunes.app"

  zap trash: "~LibraryPreferencesdigital.twisted.noTunes.plist"
end