cask "gitee" do
  version "1.0.2.7"
  sha256 "9eec18ba7c2e4458223916bca87d7221c2b38b345a6aae087b5a3a3ab5059299"

  url "https:github.comNightonkeGiteereleasesdownloadv#{version}Gitee.zip"
  name "Gitee"
  desc "Status bar application for GitHub"
  homepage "https:github.comNightonkeGitee"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-11", because: :unmaintained

  app "Gitee.app"

  zap trash: [
    "~LibraryApplication Supportcom.nightonke.VHGithubNotifier",
    "~LibraryCachescom.nightonke.VHGithubNotifier",
    "~LibraryCookiescom.nightonke.VHGithubNotifier.binarycookies",
    "~LibraryPreferencescom.nightonke.VHGithubNotifier.plist",
  ]

  caveats do
    requires_rosetta
  end
end