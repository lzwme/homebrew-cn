cask "vlc@nightly" do
  arch arm: "arm64", intel: "x86_64"
  livecheck_arch = on_arch_conditional arm: "-arm64", intel: "-intel64"

  on_arm do
    version "4.0.0,20241030-0413,9a0d9c98"
    sha256 "6453bbc7f9a7f852913a089817c3356a60afd36c52e7cca392a7b43f47e50d7a"

    url "https:artifacts.videolan.orgvlcnightly-macos-#{arch}#{version.csv.second}vlc-#{version.csv.first}-dev-arm64-#{version.csv.third}.dmg"
  end
  on_intel do
    version "4.0.0,20241030-0411,9a0d9c98"
    sha256 "6ee541336fce636a018f0b4d3985f612abbe114d31a3f20a401145ba855f0543"

    url "https:artifacts.videolan.orgvlcnightly-macos-#{arch}#{version.csv.second}vlc-#{version.csv.first}-dev-intel64-#{version.csv.third}.dmg"
  end

  name "VLC media player"
  desc "Open-source cross-platform multimedia player"
  homepage "https:www.videolan.orgvlc"

  livecheck do
    url "https:artifacts.videolan.orgvlcnightly-macos-#{arch}"
    regex(href=.*?vlc[._-]v?(\d+(?:\.\d+)+)-dev#{livecheck_arch}-(\h+)\.dmgi)
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

  deprecate! date: "2025-05-01", because: :unsigned

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