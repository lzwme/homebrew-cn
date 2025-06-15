cask "yu-writer" do
  version "0.5.3"
  sha256 "4fff4042c6ac7c047097c5e6d59a8a1c3f9dacfbdcadb3121904426413b38e06"

  url "https:github.comivarptryu-writer.sitereleasesdownloadv#{version}yu-writer-beta-#{version}-macos.dmg",
      verified: "github.comivarptryu-writer.site"
  name "Yu Writer"
  desc "Markdown editor"
  homepage "https:ivarptr.github.ioyu-writer.site"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Yu Writer.app"

  zap trash: [
    "~LibraryApplication SupportYu Writer",
    "~LibraryCachesYu Writer",
    "~LibraryPreferencescom.github.yu-writer.helper.plist",
    "~LibraryPreferencescom.github.yu-writer.plist",
  ]
end