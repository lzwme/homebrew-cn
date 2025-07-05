cask "profilecreator" do
  version "0.3.7"
  sha256 "8579e70603a932faa8498181056e09469fa55b3fc2d0397fba165ac21f3a84ba"

  url "https://ghfast.top/https://github.com/ProfileCreator/ProfileCreator/releases/download/#{version}/ProfileCreator-#{version}.dmg"
  name "ProfileCreator"
  desc "Create standard or customised configuration profiles"
  homepage "https://github.com/ProfileCreator/ProfileCreator"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "ProfileCreator.app"

  zap trash: [
    "~/Library/Application Support/ProfileCreator",
    "~/Library/Application Support/ProfilePayloads",
    "~/Library/Preferences/com.github.ProfileCreator.plist",
  ]
end