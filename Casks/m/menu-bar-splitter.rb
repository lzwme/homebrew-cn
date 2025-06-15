cask "menu-bar-splitter" do
  version "2.0.1"
  sha256 "3a48c97cb3594933c5b2f97b0e31373a45847b8aefec7aeceaf7f0ea350b789e"

  url "https:github.comjwhamilton99menu-bar-splitterreleasesdownload#{version}menu-bar-splitter.zip"
  name "Menu Bar Splitter"
  desc "Utility that adds dividers to your menu bar"
  homepage "https:github.comjwhamilton99menu-bar-splitter"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :catalina"

  app "Menu Bar Splitter.app"

  zap trash: [
    "~LibraryApplication Scriptsjustinhamilton.Menu-Bar-Splitter",
    "~LibraryApplication Scriptsjustinhamilton.Menu-Bar-Splitter-AutoLaunch",
    "~LibraryContainersjustinhamilton.Menu-Bar-Splitter",
    "~LibraryContainersjustinhamilton.Menu-Bar-Splitter-AutoLaunch",
  ]
end