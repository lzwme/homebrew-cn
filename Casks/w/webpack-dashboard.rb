cask "webpack-dashboard" do
  version "1.0.0"
  sha256 "aecc8a4831c8ca9d709c789821c6971f341596bccde8f6bf255cfeda3ecf43eb"

  url "https:github.comFormidableLabselectron-webpack-dashboardreleasesdownloadv#{version}webpack-dashboard-app-#{version}.dmg"
  name "Webpack Dashboard"
  desc "Electron Desktop GUI for Webpack Dashboard"
  homepage "https:github.comFormidableLabselectron-webpack-dashboard"

  app "Webpack Dashboard.app"

  zap trash: [
    "~LibraryApplication Supportwebpack-dashboard-app",
    "~LibraryPreferencesorg.formidable.WebpackDashboard.helper.plist",
    "~LibraryPreferencesorg.formidable.WebpackDashboard.plist",
    "~LibrarySaved Application Stateorg.formidable.WebpackDashboard.savedState",
  ]

  caveats do
    discontinued
  end
end