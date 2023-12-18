cask "devdocs" do
  version "0.7.2"
  sha256 "88e4c14cd5b7f856796764591107e4e8e78a82de1384b737536a56d97b389f2d"

  url "https:github.comegoistdevdocs-desktopreleasesdownloadv#{version}DevDocs-#{version}.dmg"
  name "DevDocs App"
  desc "Full-featured desktop app for DevDocs.io"
  homepage "https:github.comegoistdevdocs-desktop"

  app "DevDocs.app"

  zap trash: [
    "~.devdocs",
    "~LibraryApplication SupportDevDocs",
    "~LibraryLogsDevDocs",
    "~LibraryPreferencessh.egoist.devdocs.plist",
    "~LibrarySaved Application Statesh.egoist.devdocs.savedState",
  ]

  caveats do
    discontinued
  end
end