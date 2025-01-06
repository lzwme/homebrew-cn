cask "gcollazo-mongodb" do
  version "7.0.3-build.2"
  sha256 "8e89523f92fa2e1bca4cfa405096f4346da15c767456303f3fb53d1edf43f26b"

  url "https:github.comgcollazomongodbappreleasesdownload#{version}MongoDB.zip",
      verified: "github.comgcollazomongodbapp"
  name "MongoDB"
  desc "App wrapper for MongoDB"
  homepage "https:gcollazo.commongodb-app"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+(?:-build[._-]?\d+)?)$i)
  end

  depends_on macos: ">= :mojave"

  app "MongoDB.app"

  zap trash: [
    "~LibraryCachesio.blimp.MongoDB",
    "~LibraryPreferencesio.blimp.MongoDB.plist",
  ]
end