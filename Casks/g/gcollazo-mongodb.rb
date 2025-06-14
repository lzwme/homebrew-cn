cask "gcollazo-mongodb" do
  version "8.0.5-build.1"
  sha256 "bc545179d510b4fc80ac9866d34228faa7153137eea8f5ebcac957abf9d3ef89"

  url "https:github.comgcollazomongodbappreleasesdownload#{version}MongoDB.zip",
      verified: "github.comgcollazomongodbapp"
  name "MongoDB"
  desc "App wrapper for MongoDB"
  homepage "https:gcollazo.commongodb-app"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+(?:-build[._-]?\d+)?)$i)
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "MongoDB.app"

  zap trash: [
    "~LibraryCachesio.blimp.MongoDB",
    "~LibraryPreferencesio.blimp.MongoDB.plist",
  ]
end