cask "almighty" do
  version "2.8.0"
  sha256 :no_check

  url "https:almighty-app.s3.amazonaws.comAlmighty.zip",
      verified: "almighty-app.s3.amazonaws.com"
  name "Almighty"
  desc "Settings and tweaks configurator"
  homepage "https:indiegoodies.comalmighty"

  livecheck do
    url "https:raw.githubusercontent.comonmyway133archivesmasterAlmightyCast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Almighty.app"

  zap trash: [
    "~LibraryApplication SupportAlmighty",
    "~LibraryApplication Supportcom.onmyway133.Almighty",
    "~LibraryCachescom.onmyway133.Almighty",
    "~LibraryPreferencescom.onmyway133.Almighty.plist",
    "~LibrarySaved Application Statecom.onmyway133.Almighty.savedState",
  ]
end