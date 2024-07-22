cask "minisim" do
  version "0.8.4"
  sha256 "f0998155c01f6a100835136a0163c43111b8d99c8b0e94108a165a2a6f5c687f"

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