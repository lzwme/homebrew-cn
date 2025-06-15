cask "mark-text" do
  arch arm: "arm64", intel: "x64"

  version "0.17.1"
  sha256 arm:   "c7fb2f9917b0626999d4fef9a1827ccc515afb1c32f7453977af5c1cbcd9de4f",
         intel: "83320faad3b217079f6638b1f4169ffc37465f255a93e262d1646f2a5f53f263"

  url "https:github.commarktextmarktextreleasesdownloadv#{version}marktext-#{arch}.dmg"
  name "MarkText"
  desc "Markdown editor"
  homepage "https:github.commarktextmarktext"

  no_autobump! because: :requires_manual_review

  auto_updates true

  app "MarkText.app"

  zap trash: [
    "~LibraryApplication Supportmarktext",
    "~LibraryLogsmarktext",
    "~LibraryPreferencescom.github.marktext.marktext.plist",
    "~LibrarySaved Application Statecom.github.marktext.marktext.savedState",
  ]

  caveats <<~EOS
    The Apple Silicon (ARM) version of #{token} is not signed. It will display an error stating it is damaged and can't
    be opened. Please see https:github.commarktextmarktextissues2983 for details and workarounds.

    This is something only the developer, not Homebrew, can fix.
  EOS
end