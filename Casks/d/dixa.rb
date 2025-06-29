cask "dixa" do
  version "4.0.12"
  sha256 "a4e1a30d074e724ba24e9e2674a72bc4050f00161fb7dc23295a2c189ecda5bb"

  url "https:github.comdixahqdixa-desktop-app-releasereleasesdownloadv#{version}dixa-#{version}.dmg",
      verified: "github.comdixahqdixa-desktop-app-release"
  name "Dixa"
  desc "Customer service platform"
  homepage "https:dixa.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "Dixa.app"

  zap trash: [
    "~LibraryApplication SupportDixa",
    "~LibraryLogsDixa",
    "~LibraryPreferencesdixa.plist",
    "~LibrarySaved Application Statedixa.savedState",
  ]

  caveats do
    requires_rosetta
  end
end