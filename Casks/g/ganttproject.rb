cask "ganttproject" do
  arch arm: "silicon", intel: "intel"

  version "3.3.3309"
  sha256 arm:   "85537f33dca107607a516e227bc0ed6a58479a4648632c7f270193b457163f43",
         intel: "52a767a34ada9683e42fcca72c5e940f9a1092c401a47e367a4c29464484990c"

  url "https:github.combardsoftwareganttprojectreleasesdownloadganttproject-#{version}ganttproject-#{version}-#{arch}.dmg",
      verified: "github.combardsoftwareganttproject"
  name "GanttProject"
  desc "Gantt chart and project management application"
  homepage "https:www.ganttproject.biz"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "GanttProject.app"

  zap trash: [
    "~.ganttproject",
    "~.ganttproject.d",
    "~LibraryPreferencescom.bardsoftware.ganttproject.plist",
  ]
end