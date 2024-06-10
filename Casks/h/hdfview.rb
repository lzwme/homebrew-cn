cask "hdfview" do
  version "3.3.2"
  sha256 "40d111afc43fe9f1138692d1fb40c1330ea4f4416a2163e5dc4b4c398fb779bf"

  url "https:github.comHDFGrouphdfviewreleasesdownloadv#{version}HDFView-#{version}-Darwin.tar.gz",
      verified: "github.comHDFGrouphdfview"
  name "HDFView"
  desc "Tool for browsing and editing HDF files"
  homepage "https:www.hdfgroup.orgdownloadshdfview"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :el_capitan"
  container nested: "HDFView-#{version}.dmg"

  app "HDFView.app"

  zap trash: [
    "~.hdfview*",
    "~LibraryPreferencesHDFView.hdfgroup.org.plist",
    "~LibrarySaved Application Statehdf.view.savedState",
  ]

  caveats do
    requires_rosetta
  end
end