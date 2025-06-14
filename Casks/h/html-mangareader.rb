cask "html-mangareader" do
  version "2.2.0"
  sha256 "83ed6b7e5d05e1fedf79628de0f0323df7f37956a86f00921ca900554a3a5ddb"

  url "https:github.comluejerryhtml-mangareaderreleasesdownloadv#{version}mangareader-macos_x86-#{version}.dmg"
  name "HTML Mangareader"
  desc "Lightweight offline CBZCBR and image viewer with full continuous scrolling"
  homepage "https:github.comluejerryhtml-mangareader"

  no_autobump! because: :requires_manual_review

  app "HTML Mangareader.app"

  zap trash: [
    "~LibraryApplication Supporthtml-mangareader",
    "~LibraryPreferencesHTML Mangareader.plist",
    "~LibrarySaved Application StateHTML Mangareader.savedState",
  ]

  caveats do
    requires_rosetta
  end
end