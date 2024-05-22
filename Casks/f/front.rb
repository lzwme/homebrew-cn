cask "front" do
  arch arm: "arm64", intel: "x64"

  version "3.54.3"
  sha256 arm:   "c3f93a5648a7ad9eb35a7c6e97283bc2bdfc074b82f871d3da3490499cc791cd",
         intel: "7110bcb786ed9d5f922bb1785c31996774f3000a25caced9341bafbd46091767"

  url "https://dl.frontapp.com/desktop/builds/#{version}/Front-#{version}-#{arch}.zip",
      verified: "dl.frontapp.com/desktop/builds/"
  name "Front"
  desc "Customer communication platform"
  homepage "https://front.com/"

  livecheck do
    url "https://dl.frontapp.com/desktop/updates/latest/mac/latest-mac.yml"
    strategy :electron_builder
  end

  depends_on macos: ">= :el_capitan"

  app "Front.app"

  zap trash: [
    "~/Library/Application Support/Front",
    "~/Library/FrontBoard",
    "~/Library/Logs/Front",
    "~/Library/Preferences/com.frontapp.Front.plist",
    "~/Library/Saved Application State/com.frontapp.Front.savedState",
  ]
end