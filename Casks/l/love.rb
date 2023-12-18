cask "love" do
  version "11.5"
  sha256 "c8ff4b57274b87772a91af4efa532721848b935eef1e0b72ac0464fb177631a5"

  url "https:github.comlove2dlovereleasesdownload#{version}love-#{version}-macos.zip",
      verified: "github.comlove2dlove"
  name "LÖVE"
  desc "2D game framework for Lua"
  homepage "https:love2d.org"

  app "love.app"
  binary "#{appdir}love.appContentsMacOSlove"

  zap trash: "~LibrarySaved Application Stateorg.love2d.love.savedState"
end