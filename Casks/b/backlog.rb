cask "backlog" do
  version "1.8.0"
  sha256 "de3747cee4d6b63ccc102c25ef9ca3ab8f21d78d2fbbc8cf34725035484e1fbd"

  url "https:github.comczytelnybacklogreleasesdownloadv#{version}Backlog-darwin-x64.zip"
  name "Backlog"
  homepage "https:github.comczytelnybacklog"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-10-30", because: :unmaintained

  app "Backlog-darwin-x64Backlog.app"

  zap trash: "~LibraryApplication SupportBacklog"

  caveats do
    requires_rosetta
  end
end