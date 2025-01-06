cask "munkiadmin" do
  version "1.8.1"
  sha256 "2037b131b298579bc0213578602e219ee43d6054d4ab5d61432b08c38bc15349"

  url "https:github.comhjuutilainenmunkiadminreleasesdownloadv#{version}MunkiAdmin-#{version}.dmg",
      verified: "github.comhjuutilainenmunkiadmin"
  name "MunkiAdmin"
  desc "Tool to manage Munki repositories"
  homepage "https:hjuutilainen.github.iomunkiadmin"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)*)$i)
  end

  depends_on macos: ">= :high_sierra"

  app "MunkiAdmin.app"

  zap trash: [
    "~LibraryApplication SupportMunkiAdmin",
    "~LibraryCachescom.hjuutilainen.MunkiAdmin",
    "~LibraryLogsMunkiAdmin",
    "~LibraryPreferencescom.hjuutilainen.MunkiAdmin.plist",
  ]
end