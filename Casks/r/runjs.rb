cask "runjs" do
  version "2.12.1"
  sha256 "7d182e0431a32ecc9e6ebc515ec4982666479b5ae2bff760f580ee88a5447e19"

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