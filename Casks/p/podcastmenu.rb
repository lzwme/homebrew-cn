cask "podcastmenu" do
  version "1.3"
  sha256 "bff1a2b2b5f6c6eac37f567fdf917b696b1ef0b203f61725e44274461f957e31"

  url "https:github.cominsideguiPodcastMenurawmasterReleasesPodcastMenu_v#{version}.zip"
  name "PodcastMenu"
  desc "Tool to display Overcast on the menu bar"
  homepage "https:github.cominsideguiPodcastMenu"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-28", because: :unmaintained

  auto_updates true
  depends_on macos: ">= :el_capitan"

  app "PodcastMenu.app"

  zap trash: [
    "~LibraryApplication Supportbr.com.guilhermerambo.PodcastMenu",
    "~LibraryCachesbr.com.guilhermerambo.PodcastMenu",
    "~LibraryPreferencesbr.com.guilhermerambo.PodcastMenu.plist",
  ]

  caveats do
    requires_rosetta
  end
end