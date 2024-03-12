cask "love" do
  version "11.5"
  sha256 "6795bb3a1656af6a2fdfe741e150787b481886d3a280327a261a3fdded586913"

  url "https:github.comlove2dlovereleasesdownload#{version}love-#{version}-macos.zip",
      verified: "github.comlove2dlove"
  name "LÖVE"
  desc "2D game framework for Lua"
  homepage "https:love2d.org"

  app "love.app"
  binary "#{appdir}love.appContentsMacOSlove"

  zap trash: "~LibrarySaved Application Stateorg.love2d.love.savedState"
end