cask "appflowy" do
  version "0.8.8"
  sha256 "2d338a6b680ac8635c8d5bad5a52f13e2b89473d75e43c1875e7bcf855d0e2f8"

  url "https:github.comAppFlowy-IOAppFlowyreleasesdownload#{version}Appflowy-#{version}-macos-universal.zip",
      verified: "github.comAppFlowy-IOAppFlowy"
  name "AppFlowy"
  desc "Open-source project and knowledge management tool"
  homepage "https:www.appflowy.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :mojave"

  app "AppFlowy.app"

  zap trash: [
    "~LibraryApplication Scriptscom.appflowy.macos",
    "~LibraryContainerscom.appflowy.macos",
  ]
end