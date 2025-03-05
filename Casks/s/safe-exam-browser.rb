cask "safe-exam-browser" do
  version "3.5"
  sha256 "adfbe6025c7008c4731dbbf7be8e5417a936be21123ad83bcdee890274002d2e"

  url "https:github.comSafeExamBrowserseb-macreleasesdownload#{version}SafeExamBrowser-#{version}.dmg",
      verified: "github.comSafeExamBrowserseb-mac"
  name "Safe Exam Browser"
  desc "Web browser environment to carry out e-assessments safely"
  homepage "https:safeexambrowser.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Safe Exam Browser.app"

  zap trash: "~LibraryPreferencesorg.safeexambrowser.SafeExamBrowser.plist"
end