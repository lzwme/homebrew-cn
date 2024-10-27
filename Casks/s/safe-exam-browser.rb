cask "safe-exam-browser" do
  version "3.4"
  sha256 "b0da44751eaf920929bb5274c735e86e3774d1feb62bf2573b58aefdbb150ffc"

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