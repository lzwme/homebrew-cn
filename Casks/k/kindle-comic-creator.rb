cask "kindle-comic-creator" do
  version "1.160"
  sha256 :no_check

  url "https://kc2.s3.amazonaws.com/KindleComicCreatorInstall.dmg",
      verified: "kc2.s3.amazonaws.com/"
  name "Kindle Comic Creator"
  desc "Turns comics, graphic novels and manga into Kindle books"
  homepage "https://www.amazon.com/b?node=23496309011"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2025-02-09", because: :unmaintained

  pkg "Kindle Comic Creator.pkg"

  uninstall launchctl: "com.amazon.KindlePreviewerUpdater",
            pkgutil:   [
              "com.amazon.kc2.kindleComicCreator*",
              "com.amazon.kc2.KindlePreviewer.pkg",
            ]

  zap trash: [
    "~/.kindle",
    "~/Library/Saved Application State/com.amazon.KC2.savedState",
  ]
end