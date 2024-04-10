cask "obsbot-center" do
  version "2.0.8.36"
  sha256 "5a7aae4779fe50a887bca7abb9575e598dc9b619215f92a9144c40076f6f48b8"

  url "https://resource-cdn.obsbothk.com/download/obsbot-center/Obsbot_Center_OA_E_MacOS_#{version}_release.dmg",
      verified: "resource-cdn.obsbothk.com/download/obsbot-center/"
  name "OBSBOT Center"
  desc "Configuration and firmware update utility for OBSBOT Tiny and Meet series"
  homepage "https://www.obsbot.com/download"

  livecheck do
    url "https://www.obsbot.com/download/obsbot-tiny-series"
    regex(/Obsbot[._-]Center[._-]OA[._-]E[._-]MacOS[._-](\d+(?:\.\d+)+)[._-]release\.dmg/i)
  end

  depends_on macos: ">= :big_sur"

  app "OBSBOT_Center.app"

  zap trash: [
    "~/Library/Application Support/OBSBOT_Center",
    "~/Library/Caches/com.obsbot.OBSBOT_Center",
    "~/Library/HTTPStorages/com.obsbot.OBSBOT_Center",
    "~/Library/Preferences/com.obsbot.OBSBOT_Center.plist",
  ]
end