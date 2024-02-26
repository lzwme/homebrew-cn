cask "runjs" do
  version "2.11.0"
  sha256 "a787f9a42a451584ffb7df39f993128d159debd3d48f163e9d3ffc42f98b3829"

  url "https:github.comlukehaasRunJSreleasesdownloadv#{version}RunJS-#{version}-universal.dmg",
      verified: "github.comlukehaasRunJS"
  name "RunJS"
  desc "JavaScript playground that auto-evaluates as code is typed"
  homepage "https:runjs.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :el_capitan"

  app "RunJS.app"

  zap trash: [
    "~LibraryApplication Supportrunjs",
    "~LibraryLogsRunJS",
    "~LibraryPreferencesme.lukehaas.runjs.plist",
    "~LibrarySaved Application Stateme.lukehaas.runjs.savedState",
  ]
end