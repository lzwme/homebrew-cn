cask "curiosity" do
  version "0.5.5"
  sha256 "cee2a11755b23c55d96a2226750e80ee991ae8bff74bda4ff757717bcbdf9cad"

  url "https:github.comDimillianRedditOSreleasesdownload#{version}Curiosity.zip"
  name "Curiosity"
  desc "SwiftUI Reddit client"
  homepage "https:github.comDimillianRedditOS"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "Curiosity.app"

  zap trash: "~LibraryContainerscom.thomasricouard.curiosity"
end