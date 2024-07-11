cask "exifcleaner" do
  version "3.6.0"
  sha256 "459b296b000a7cd614713772e9b4ecf1604d3bb10926ab2346e8ea88e44df323"

  url "https:github.comszTheoryexifcleanerreleasesdownloadv#{version}ExifCleaner-#{version}.dmg",
      verified: "github.comszTheoryexifcleaner"
  name "ExifCleaner"
  desc "Metadata cleaner"
  homepage "https:exifcleaner.com"

  app "ExifCleaner.app"

  zap trash: [
    "~LibraryApplication SupportExifCleaner",
    "~LibrarySaved Application Statecom.exifcleaner.savedState",
  ]

  caveats do
    requires_rosetta
  end
end