cask "subtitle-master" do
  version "2.0.1"
  sha256 "8936495ef4aefe9bf59c28dd4d5a92574c194062067c318667e3f55428245304"

  url "https:github.comsubtitle-mastersubtitlemasterreleasesdownloadv#{version}-SNAPSHOTSubtitle.Master-osx-v#{version}-SNAPSHOT.zip"
  name "Subtitle Master"
  desc "Search for subtitles"
  homepage "https:github.comsubtitle-mastersubtitlemaster"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)(?:-SNAPSHOT)?$i)
  end

  app "Subtitle Master.app"
end