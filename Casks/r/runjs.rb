cask "runjs" do
  version "3.1.1"
  sha256 "030d92704a6cb2690c533c20ac0b7b958a9c6f01a8d9484904d15f851ca80b3f"

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