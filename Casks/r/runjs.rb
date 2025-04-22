cask "runjs" do
  version "3.1.0"
  sha256 "2e25468b8c2819a3e8af231325d0a3c0dbbc048ac9530ae658d08cc24c1f122e"

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