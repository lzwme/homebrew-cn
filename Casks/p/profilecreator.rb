cask "profilecreator" do
  version "0.3.2,201907171032-beta"
  sha256 "a4a1b45bfaa6bc83aac7ef532981aaa0c807cd17fbfb1f157980144e5d309aea"

  url "https:github.comerikberglundProfileCreatorreleasesdownloadv#{version.csv.first}ProfileCreator_v#{version.csv.first}-#{version.csv.second}.dmg"
  name "ProfileCreator"
  desc "Create standard or customized configuration profiles"
  homepage "https:github.comerikberglundProfileCreator"

  deprecate! date: "2023-12-17", because: :discontinued

  depends_on macos: ">= :sierra"

  app "ProfileCreator.app"

  zap trash: [
    "~LibraryApplication SupportProfileCreator",
    "~LibraryApplication SupportProfilePayloads",
    "~LibraryPreferencescom.github.erikberglund.ProfileCreator.plist",
  ]
end