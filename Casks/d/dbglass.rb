cask "dbglass" do
  version "0.1.0-beta.6"
  sha256 "f79f853299f7578f3b30a9df9b2d027ec73ecf933b91f78e287ad2993176f45d"

  url "https:github.comweb-palDBGlassreleasesdownloadv#{version}MAC_OS-X.zip",
      verified: "github.comweb-palDBGlass"
  name "DBGlass"
  desc "PostgreSQL client built with Electron"
  homepage "http:dbglass.web-pal.com"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "DBGlass-darwin-x64DBGlass.app"
end