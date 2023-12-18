cask "todotxt" do
  version "2.4.0"
  sha256 "67f94669661e5b2186f3b619465d18206d8e20ae082d672c86b17d766f59fd41"

  url "https:github.commjdescyTodoTxtMacreleasesdownload#{version}TodoTxtMac.app.zip",
      verified: "github.commjdescyTodoTxtMac"
  name "TodoTxtMac"
  desc "Minimalist, keyboard-driven to-do manager"
  homepage "https:mjdescy.github.ioTodoTxtMac"

  app "TodoTxtMac.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.descy.michael.todotxtmac.sfl2",
    "~LibraryPreferencescom.descy.michael.TodoTxtMac.plist",
  ]
end