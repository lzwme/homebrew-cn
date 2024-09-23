cask "minisim" do
  version "0.9.0"
  sha256 "467b92b291e9f28f755f245d21018045242d11dd703db414c1d078852abf971f"

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