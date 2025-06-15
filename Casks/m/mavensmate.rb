cask "mavensmate" do
  version "0.0.11"
  sha256 "a16344436cebb550f57d3800bf47f3176e2135701462dcd2b41c7f02192d5fd7"

  url "https:github.comjoeferraroMavensMate-Desktopreleasesdownloadv#{version}MavensMate-#{version}.dmg"
  name "MavensMate"
  desc "Packaged desktop app for MavensMate server"
  homepage "https:github.comjoeferraroMavensMate-Desktop"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "MavensMate.app"
end