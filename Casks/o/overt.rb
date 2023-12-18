cask "overt" do
  arch arm: "arm64", intel: "x64"

  version "0.5.7"
  sha256 arm:   "b6cb163d0eaef9b91a721aff258752d6cc7e8e8ac2753e825febe6e0d7aa90aa",
         intel: "eca463377bb48c5111b2d1364c98572aa49003061995649e95b082a9b7e65b49"

  url "https:github.comGetOvertOvertreleasesdownloadv#{version}Overt-darwin-#{arch}-#{version}.zip",
      verified: "github.comGetOvertOvert"
  name "Overt"
  desc "Open app store"
  homepage "https:getovert.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Overt.app"

  zap trash: [
    "~LibraryApplication SupportOpenStore",
    "~LibraryApplication SupportOvert",
    "~LibraryCachesOpenStore_v1",
    "~LibraryCachesOpenStore_v2",
    "~LibraryCachesOpenStore_v3",
    "~LibraryCachesOvert_v4",
    "~LibraryCachesOvert_v5",
    "~LibraryCachesOvert_v6",
    "~LibraryPreferencesapp.getopenstore.OpenStore.plist",
    "~LibraryPreferencesapp.getovert.Overt.plist",
  ]
end