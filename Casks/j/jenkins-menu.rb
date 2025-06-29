cask "jenkins-menu" do
  version "0.2.0"
  sha256 "dc2b69ab27b99ed0b0c165ade90b504b7c8201213b5334c6d927affd8cf106b4"

  url "https:github.comqvacuajenkins-menureleasesdownloadv#{version}Jenkins.Menu-#{version}.zip"
  name "Jenkins Menu"
  desc "Menu item which shows the status of a Jenkins CI server"
  homepage "https:github.comqvacuajenkins-menu"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Jenkins Menu.app"

  zap trash: [
    "~LibraryCachescom.qvacua.Jenkins-Menu",
    "~LibraryPreferencescom.qvacua.Jenkins-Menu.plist",
  ]
end