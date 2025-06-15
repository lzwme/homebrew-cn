cask "webpack-dashboard" do
  version "1.0.0"
  sha256 "aecc8a4831c8ca9d709c789821c6971f341596bccde8f6bf255cfeda3ecf43eb"

  url "https:github.comFormidableLabselectron-webpack-dashboardreleasesdownloadv#{version}webpack-dashboard-app-#{version}.dmg"
  name "Webpack Dashboard"
  desc "Electron Desktop GUI for Webpack Dashboard"
  homepage "https:github.comFormidableLabselectron-webpack-dashboard"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Webpack Dashboard.app"

  zap trash: [
    "~LibraryApplication Supportwebpack-dashboard-app",
    "~LibraryPreferencesorg.formidable.WebpackDashboard.helper.plist",
    "~LibraryPreferencesorg.formidable.WebpackDashboard.plist",
    "~LibrarySaved Application Stateorg.formidable.WebpackDashboard.savedState",
  ]
end