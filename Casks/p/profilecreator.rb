cask "profilecreator" do
  version "0.3.7"
  sha256 "8579e70603a932faa8498181056e09469fa55b3fc2d0397fba165ac21f3a84ba"

  url "https:github.comProfileCreatorProfileCreatorreleasesdownload#{version}ProfileCreator-#{version}.dmg"
  name "ProfileCreator"
  desc "Create standard or customised configuration profiles"
  homepage "https:github.comProfileCreatorProfileCreator"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "ProfileCreator.app"

  zap trash: [
    "~LibraryApplication SupportProfileCreator",
    "~LibraryApplication SupportProfilePayloads",
    "~LibraryPreferencescom.github.ProfileCreator.plist",
  ]
end