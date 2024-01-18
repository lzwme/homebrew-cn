cask "appflowy" do
  version "0.4.3"
  sha256 "20949035ca0ed32ad836b45ffc96a9f9b32b7d0cc2fbee8aeda11d272d3ecf1f"

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