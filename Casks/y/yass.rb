cask "yass" do
  arch arm: "-arm64", intel: "-x64"

  version "1.10.2"
  sha256 arm:   "a2ccbb736c93d0ba3e7f1628d944d37624f35032ed26caa3932ebc0f3ebc5d3c",
         intel: "12d273b3d1fe7f16e2e5f26970526be05a5aa75cc1df911bca9b49389be02891"

  url "https:github.comChilledheartyassreleasesdownload#{version}yass-macos-release#{arch}-#{version}.dmg"
  name "YASS"
  desc "Yet Another Shadow Socket"
  homepage "https:github.comChilledheartyass"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :mojave"

  app "yass.app"
  binary "#{appdir}yass.appContentsMacOSyass"

  zap trash: [
    "~LibraryPreferencesit.gui.yass.plist",
    "~LibraryPreferencesit.gui.yass.suite.plist",
  ]
end