cask "pictureview" do
  version "2.3.4"
  sha256 "3975d6e10f8e04e4339eadeafd0af511611fd9ba852d4c3e724dbbb3d811abce"

  url "https:wl879.github.ioappspicviewPictureView_#{version}.dmg"
  name "Picture View"
  desc "Image viewer"
  homepage "https:wl879.github.ioappspicviewindex.html"

  livecheck do
    url "https:raw.githubusercontent.comwl879wl879.github.iomasterappspicviewappcase.xml"
    strategy :sparkle, &:short_version
  end

  depends_on macos: ">= :catalina"

  app "PictureView.app"

  zap trash: [
    "~LibraryPreferencescom.zouke.PictureView.plist",
    "~LibrarySaved Application Statecom.zouke.PictureView.savedState",
  ]
end