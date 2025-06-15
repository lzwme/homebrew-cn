cask "todotxt" do
  version "2.4.0"
  sha256 "67f94669661e5b2186f3b619465d18206d8e20ae082d672c86b17d766f59fd41"

  url "https:github.commjdescyTodoTxtMacreleasesdownload#{version}TodoTxtMac.app.zip",
      verified: "github.commjdescyTodoTxtMac"
  name "TodoTxtMac"
  desc "Minimalist, keyboard-driven to-do manager"
  homepage "https:mjdescy.github.ioTodoTxtMac"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-08-30", because: :unmaintained

  app "TodoTxtMac.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.descy.michael.todotxtmac.sfl*",
    "~LibraryPreferencescom.descy.michael.TodoTxtMac.plist",
  ]

  caveats do
    requires_rosetta
  end
end