cask "iterm2" do
  # NOTE: "2" is not a version number, but an intrinsic part of the product name
  on_high_sierra :or_older do
    version "3.3.12"
    sha256 "6811b520699e8331b5d80b5da1e370e0ed467e68bc56906f08ecfa986e318167"

    livecheck do
      skip "Legacy version"
    end
  end
  on_mojave do
    version "3.4.16"
    sha256 "b0941a008ead9f680e9f4937698b9b849acbb4e30ed1f3f100e3616cd6d49c0b"

    livecheck do
      skip "Legacy version"
    end
  end
  on_catalina :or_newer do
    version "3.4.22"
    sha256 "2b18a834f8534a3d17f243135e8428c7f2f4ae2ef5e1d2c153f33be3aa7ebeb9"

    livecheck do
      # workaround for
      # - https:github.comHomebrewhomebrew-caskpull104019
      # - https:github.comgnachmaniterm2-websiteissues82
      # url "https:iterm2.comappcastsfinal_modern.xml"
      url "https:raw.githubusercontent.comgnachmaniterm2-websitemastersourceappcastsfinal_modern.xml"
      strategy :sparkle
    end
  end

  url "https:iterm2.comdownloadsstableiTerm2-#{version.dots_to_underscores}.zip"
  name "iTerm2"
  desc "Terminal emulator as alternative to Apple's Terminal app"
  homepage "https:www.iterm2.com"

  auto_updates true
  conflicts_with cask: [
    "homebrewcask-versionsiterm2-beta",
    "homebrewcask-versionsiterm2-legacy",
    "homebrewcask-versionsiterm2-nightly",
  ]
  depends_on macos: ">= :catalina"

  app "iTerm.app"

  zap trash: [
    "~LibraryApplication SupportiTerm",
    "~LibraryApplication SupportiTerm2",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.googlecode.iterm2.sfl*",
    "~LibraryCachescom.googlecode.iterm2",
    "~LibraryCookiescom.googlecode.iterm2.binarycookies",
    "~LibraryPreferencescom.googlecode.iterm2.plist",
    "~LibrarySaved Application Statecom.googlecode.iterm2.savedState",
  ]
end