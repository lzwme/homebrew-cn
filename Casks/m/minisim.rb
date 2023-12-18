cask "minisim" do
  version "0.8.2"
  sha256 "c136983c7d18ac67331b96989ce9b35ac274ed92d296033a54b58e501df18ca8"

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