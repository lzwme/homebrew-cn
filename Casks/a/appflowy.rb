cask "appflowy" do
  version "0.8.3"
  sha256 "32f509da59ab5f1a8e1c93bd5c7baef4dadf479859ca4f49c232097b5117fd6d"

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