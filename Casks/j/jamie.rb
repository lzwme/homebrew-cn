cask "jamie" do
  version "4.0.4"
  sha256 "2971c57d9948ba548ed02ae15eff2958e92592dbc92d53ad921e4c0211d46696"

  url "https:github.comlouismorgnerjamie-releasereleasesdownloadv#{version}jamie-#{version}.dmg",
      verified: "github.comlouismorgnerjamie-release"
  name "jamie"
  desc "AI-powered meeting notes"
  homepage "https:meetjamie.ai"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "jamie.app"

  zap trash: "~LibraryApplication Supportjamie"
end