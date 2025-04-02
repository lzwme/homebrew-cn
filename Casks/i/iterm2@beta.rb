cask "iterm2@beta" do
  # NOTE: "2" is not a version number, but an intrinsic part of the product name
  version "3.5.12beta4"
  sha256 "5390c683782ef792556d4b2f368e82a5957ae8966a166a7dc0c14f1babfeb813"

  url "https:iterm2.comdownloadsbetaiTerm2-#{version.dots_to_underscores}.zip"
  name "iTerm2"
  desc "Terminal emulator as alternative to Apple's Terminal app"
  homepage "https:iterm2.com"

  livecheck do
    # workaround for
    # - https:github.comHomebrewhomebrew-caskpull104019
    # - https:github.comgnachmaniterm2-websiteissues82
    # url "https:iterm2.comappcaststesting_modern.xml"
    url "https:raw.githubusercontent.comgnachmaniterm2-websitemastersourceappcaststesting_modern.xml"
    strategy :sparkle, &:version
  end

  auto_updates true
  conflicts_with cask: [
    "iterm2",
    "iterm2@nightly",
  ]
  depends_on macos: ">= :catalina"

  app "iTerm.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.googlecode.iterm2.sfl*",
    "~LibraryApplication SupportiTerm",
    "~LibraryApplication SupportiTerm2",
    "~LibraryCachescom.googlecode.iterm2",
    "~LibraryPreferencescom.googlecode.iterm2.plist",
    "~LibrarySaved Application Statecom.googlecode.iterm2.savedState",
  ]
end