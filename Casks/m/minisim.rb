cask "minisim" do
  version "0.8.3"
  sha256 "81fff5db71728bc11e62cd449aed3bfa90e2938e51fbcab2d7e14ac6dc7abe3e"

  url "https:github.comokwasniewskiMiniSimreleasesdownloadv#{version}MiniSim.app.zip",
      verified: "github.comokwasniewskiMiniSim"
  name "MiniSim"
  desc "App for launching iOS and Android simulators"
  homepage "https:www.minisim.app"

  depends_on macos: ">= :big_sur"

  app "MiniSim.app"

  uninstall quit: "com.oskarkwasniewski.MiniSim"

  zap trash: [
    "~LibraryHTTPStoragescom.oskarkwasniewski.MiniSim",
    "~LibraryPreferencescom.oskarkwasniewski.MiniSim.plist",
  ]
end