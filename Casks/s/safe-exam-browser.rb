cask "safe-exam-browser" do
  version "3.3.3"
  sha256 "a6108ac1697563d35809fad87794bd96701975570b7ce51333c457018b380812"

  url "https:github.comSafeExamBrowserseb-macreleasesdownload#{version}SafeExamBrowser-#{version}.dmg",
      verified: "github.comSafeExamBrowserseb-mac"
  name "Safe Exam Browser"
  desc "Web browser environment to carry out e-assessments safely"
  homepage "https:safeexambrowser.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :el_capitan"

  app "Safe Exam Browser.app"

  zap trash: "~LibraryPreferencesorg.safeexambrowser.SafeExamBrowser.plist"
end