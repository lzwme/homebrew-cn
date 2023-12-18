cask "mu-editor" do
  version "1.2.0"
  sha256 "306bef4ebfafd1dcf928bc260d5d57e64efbccb537b27f5818a9fc12437726b6"

  url "https:github.commu-editormureleasesdownloadv#{version}MuEditor-osx-#{version}.dmg",
      verified: "github.commu-editormu"
  name "Mu"
  desc "Small, simple editor for beginner Python programmers"
  homepage "https:codewith.mu"

  app "Mu Editor.app"

  zap rmdir: "~mu_code",
      trash: [
        "~LibraryApplication Supportmu",
        "~LibraryLogsmu",
      ]
end