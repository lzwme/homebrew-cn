cask "vlc@nightly" do
  arch arm: "arm64", intel: "x86_64"
  livecheck_arch = on_arch_conditional arm: "arm64", intel: "intel64"

  on_arm do
    version "4.0.0,20250314-0413,6dca281b"
    sha256 "76cffa9fbda12f4350fb7c3174d7ea867bdab2172c07381ad47b2998f6f5bd39"
  end
  on_intel do
    version "4.0.0,20250314-0411,6dca281b"
    sha256 "b9b88e4a47e8453ce776c43b722cd5a2ae3fad42a233d297f1e52afce9c4061a"
  end

  url "https:artifacts.videolan.orgvlcnightly-macos-#{arch}#{version.csv.second}vlc-#{version.csv.first}-dev-#{livecheck_arch}-#{version.csv.third}.dmg"
  name "VLC media player"
  desc "Open-source cross-platform multimedia player"
  homepage "https:www.videolan.orgvlc"

  livecheck do
    url "https:artifacts.videolan.orgvlcnightly-macos-#{arch}"
    regex(href=.*?vlc[._-]v?(\d+(?:\.\d+)+)[._-]dev[._-]#{livecheck_arch}[._-](\h+)\.dmgi)
    strategy :page_match do |page, regex|
      directory = page.scan(%r{href=["']?v?(\d+(?:[.-]\d+)+)?["' >]}i)
                      .flatten
                      .uniq
                      .max
      next if directory.blank?

      # Fetch the directory listing page for newest build
      build_response = Homebrew::Livecheck::Strategy.page_content(
        "https:artifacts.videolan.orgvlcnightly-macos-#{arch}#{directory}",
      )
      next if (build_page = build_response[:content]).blank?

      match = build_page.match(regex)
      next if match.blank?

      "#{match[1]},#{directory},#{match[2]}"
    end
  end

  conflicts_with cask: "vlc"

  app "VLC.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}vlc.wrapper.sh"
  binary shimscript, target: "vlc"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}VLC.appContentsMacOSVLC' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.videolan.vlc.sfl*",
    "~LibraryApplication Supportorg.videolan.vlc",
    "~LibraryApplication SupportVLC",
    "~LibraryCachesorg.videolan.vlc",
    "~LibraryPreferencesorg.videolan.vlc",
    "~LibraryPreferencesorg.videolan.vlc.plist",
    "~LibrarySaved Application Stateorg.videolan.vlc.savedState",
  ]
end