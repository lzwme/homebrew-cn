cask "caffeine" do
  version "1.1.3"
  sha256 "240e5ab832a25ed0af43aeffd1d66dc663dfea7c2525d918c214d6107981a03b"

  url "https:github.comIntelliScapecaffeinereleasesdownload#{version}Caffeine.dmg",
      verified: "github.comIntelliScapecaffeine"
  name "Caffeine"
  desc "Utility that prevents the system from going to sleep"
  homepage "https:intelliscapesolutions.comappscaffeine"

  app "Caffeine.app"

  uninstall quit: "com.intelliscapesolutions.caffeine"

  zap trash: [
    "~LibraryApplication Supportcom.intelliscapesolutions.caffeine",
    "~LibraryPreferencescom.intelliscapesolutions.caffeine.plist",
    "~LibraryCachescom.intelliscapesolutions.caffeine",
    "~LibraryHTTPStoragescom.intelliscapesolutions.caffeine.binarycookies",
  ]

  caveats do
    requires_rosetta
  end
end