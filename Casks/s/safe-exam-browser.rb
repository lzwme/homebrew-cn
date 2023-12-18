cask "safe-exam-browser" do
  version "3.3"
  sha256 "db671f4a61ea1ca14b1c56e1cf5334669cd86307ce62c030e710ab3e7347e627"

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