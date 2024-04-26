cask "appflowy" do
  version "0.5.5"
  sha256 "69a59896fa6ffaf9b4f9797ffa4bd40f94c458a82dd998189f38e78a11c919d5"

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