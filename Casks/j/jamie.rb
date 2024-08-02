cask "jamie" do
  arch arm: "-arm64"

  version "4.2.0"
  sha256 arm:   "8a624240bc573a347d5cac0f499891c18366dbd7574cf7b31d3cade0cff141dc",
         intel: "d02cef3e1bcbb3d3c6d83d3295b4c2bd658c5e1203ff35975d5ea5bd3d0163d3"

  url "https:github.comlouismorgnerjamie-releasereleasesdownloadv#{version}jamie-#{version}#{arch}.dmg",
      verified: "github.comlouismorgnerjamie-release"
  name "jamie"
  desc "AI-powered meeting notes"
  homepage "https:meetjamie.ai"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "jamie.app"

  zap trash: "~LibraryApplication Supportjamie"
end