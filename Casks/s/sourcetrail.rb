cask "sourcetrail" do
  version "2021.4.19"
  sha256 "b2155e5b1f6f97b466d404821a61b57d4db0040356cd7487827ea9a003d65291"

  url "https:github.comCoatiSoftwareSourcetrailreleasesdownload#{version}Sourcetrail_#{version.dots_to_underscores}_macOS_64bit.dmg",
      verified: "github.comCoatiSoftwareSourcetrail"
  name "Sourcetrail"
  desc "Code source explorer"
  homepage "https:www.sourcetrail.com"

  deprecate! date: "2023-12-17", because: :discontinued

  app "Sourcetrail.app"

  zap trash: [
    "~LibraryApplication SupportSourcetrail",
    "~LibrarySaved Application Statecom.sourcetrail.savedState",
  ]
end