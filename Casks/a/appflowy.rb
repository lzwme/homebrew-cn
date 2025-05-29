cask "appflowy" do
  arch arm: "arm64", intel: "x86_64"

  version "0.9.3"
  sha256 arm:   "e488c92ac54c64cc0c15d2d9f18313cdd08014902d0c224e31485e3fa3414fea",
         intel: "bf108a1adcb153c37f0b8404ffda069a33fd5d2adbf847a5d3ec40c14f62c507"

  url "https:github.comAppFlowy-IOAppFlowyreleasesdownload#{version}Appflowy-#{version}-macos-#{arch}.zip",
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