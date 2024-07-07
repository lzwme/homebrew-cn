cask "safe-exam-browser" do
  version "3.3.3"
  sha256 "e88b82ac7cc2869e9ace9952023489b5fc7b7b4c885f08f261c452dc631daa81"

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