cask "jenkins-menu" do
  version "0.2.0"
  sha256 "dc2b69ab27b99ed0b0c165ade90b504b7c8201213b5334c6d927affd8cf106b4"

  url "https://ghproxy.com/https://github.com/qvacua/jenkins-menu/releases/download/v#{version}/Jenkins.Menu-#{version}.zip"
  name "Jenkins Menu"
  desc "Menu item which shows the status of a Jenkins CI server"
  homepage "https://github.com/qvacua/jenkins-menu/"

  app "Jenkins Menu.app"

  zap trash: [
    "~/Library/Caches/com.qvacua.Jenkins-Menu",
    "~/Library/Preferences/com.qvacua.Jenkins-Menu.plist",
  ]

  caveats do
    discontinued
  end
end