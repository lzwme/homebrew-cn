cask "dbglass" do
  version "0.1.0-beta.6"
  sha256 "f79f853299f7578f3b30a9df9b2d027ec73ecf933b91f78e287ad2993176f45d"

  url "https:github.comweb-palDBGlassreleasesdownloadv#{version}MAC_OS-X.zip",
      verified: "github.comweb-palDBGlass"
  name "DBGlass"
  desc "PostgreSQL client built with Electron"
  homepage "http:dbglass.web-pal.com"

  deprecate! date: "2023-12-17", because: :discontinued

  app "DBGlass-darwin-x64DBGlass.app"
end