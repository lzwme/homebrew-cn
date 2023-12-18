cask "backlog" do
  version "1.8.0"
  sha256 "de3747cee4d6b63ccc102c25ef9ca3ab8f21d78d2fbbc8cf34725035484e1fbd"

  url "https:github.comczytelnybacklogreleasesdownloadv#{version}Backlog-darwin-x64.zip",
      verified: "github.comczytelnybacklog"
  name "Backlog"
  homepage "http:www.backlog.cloud"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Backlog-darwin-x64Backlog.app"

  zap trash: "~LibraryApplication SupportBacklog"
end