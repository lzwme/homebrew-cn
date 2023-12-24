cask "heynote" do
  arch arm: "arm64", intel: "x64"

  version "1.4.2"
  sha256 arm:   "ad9365e72c2780c4650fb8b0162c8b5e22fa4e66386bf3d89ffaecee68710550",
         intel: "0256901223dcf669a1a7877831ab70bc5f276c8eddf26da0d3033eac19d82166"

  url "https:github.comheymanheynotereleasesdownloadv#{version}Heynote_#{version}_#{arch}.dmg",
      verified: "github.comheymanheynote"
  name "Heynote"
  desc "Dedicated scratchpad for developers"
  homepage "https:heynote.com"

  depends_on macos: ">= :catalina"

  app "Heynote.app"

  zap trash: [
    "~LibraryApplication SupportHeynote",
    "~LibraryLogsHeynote",
    "~LibrarySaved Application Statecom.heynote.app.savedState",
  ]
end