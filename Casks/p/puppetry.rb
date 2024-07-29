cask "puppetry" do
  version "3.2.6"
  sha256 "740b4892c1c7ed4164f1b9adcf2b9f27b2499d559e32029cd9af98f97b71cbfd"

  url "https:github.comdsheikopuppetryreleasesdownloadv#{version}puppetry-mac-v#{version}.zip",
      verified: "github.comdsheikopuppetry"
  name "Puppetry"
  desc "Web testing solution for non-developers on top of Puppeteer and Jest"
  homepage "https:puppetry.app"

  app "puppetry.app"

  zap trash: [
    "~LibraryApplication Supportpuppetry",
    "~LibraryPreferencescom.dsheiko.puppetry.plist",
    "~LibrarySaved Application Statecom.dsheiko.puppetry.savedState",
  ]

  caveats do
    requires_rosetta
  end
end