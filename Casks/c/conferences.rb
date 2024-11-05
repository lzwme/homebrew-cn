cask "conferences" do
  version "0.0.1-alpha22"
  sha256 "61cd7c47ecc718613c9e1ba803ae36e26c37c98bb6a46b5ced2898942c9771a5"

  url "https:github.comzagahrConferences.digitalreleasesdownload#{version}Conferences_v#{version}.zip"
  name "Conferences.digital"
  desc "App to watch conference videos"
  homepage "https:github.comzagahrConferences.digital"

  livecheck do
    url "https:zagahr.github.ioConferences.digitalappcast.xml"
    regex(_v(\d+(?:\.\d+)*-.*?)\.zipi)
    strategy :sparkle do |item, regex|
      item.url[regex, 1]
    end
  end

  depends_on macos: ">= :mojave"

  app "Conferences.app"

  zap trash: [
    "~LibraryApplication Supportdigital.conferences.macos",
    "~LibraryCachesdigital.conferences.macos",
    "~LibraryHTTPStoragesdigital.conferences.macos",
    "~LibraryPreferencesdigital.conferences.macos.plist",
    "~LibrarySaved Application Statedigital.conferences.macos.savedState",
    "~LibraryWebKitdigital.conferences.macos",
  ]

  caveats do
    requires_rosetta
  end
end