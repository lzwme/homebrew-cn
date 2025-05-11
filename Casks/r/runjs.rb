cask "runjs" do
  version "3.1.2"
  sha256 "39a1cf53d29d6c13ee798064671d64896834a7ee8f4e5d3e7f9d769080545763"

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
  depends_on macos: ">= :catalina"

  app "RunJS.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsme.lukehaas.runjs.sfl*",
    "~LibraryApplication Supportrunjs",
    "~LibraryLogsRunJS",
    "~LibraryPreferencesme.lukehaas.runjs.plist",
    "~LibrarySaved Application Stateme.lukehaas.runjs.savedState",
  ]
end