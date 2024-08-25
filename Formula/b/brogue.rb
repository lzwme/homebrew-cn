class Brogue < Formula
  desc "Roguelike game"
  homepage "https:sites.google.comsitebroguegame"
  url "https:github.comtmewettBrogueCEarchiverefstagsv1.14.tar.gz"
  sha256 "9e26a3e3612f08d3785846e73e6b8862cf4682f7a95aa9028bb8175b60f33d47"
  license "AGPL-3.0-or-later"
  head "https:github.comtmewettBrogueCE.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "ab9d6e2106ea80faab9368f5a332a4c1669c93a3b1e208a539bc89ada70f1258"
    sha256 arm64_ventura:  "4d12ef7bd353126fb20f1fc570663b191de8b76d92bacee5fbf38d3b6443baa3"
    sha256 arm64_monterey: "04cb11b5a98eeb18d074c0543001821e97f30bd66773014a49624a71a7e4a8a9"
    sha256 sonoma:         "518d83dcdbb1a88601fc324e1d4fcc797fb4980cae7509a8965bb200e6aebac4"
    sha256 ventura:        "2afdc47cf230ce52c5d90d77863d8c1051d4a83d150a767305b26740d9bdf7d1"
    sha256 monterey:       "bb655734da840f3780b78c22d206497ef1ffe47cfe7d7b43c496a19be862b3f6"
    sha256 x86_64_linux:   "464734402d11d7b26a51d8c1a214724dd1f3a3df531b54950ad011d1ff2fcaef"
  end

  depends_on "sdl2"
  depends_on "sdl2_image"

  uses_from_macos "ncurses"

  # build patch for sdl_image.h include, remove in next release
  patch do
    url "https:github.comtmewettBrogueCEcommitbaff9b5081c60ec3c0117913e419fa05126025db.patch?full_index=1"
    sha256 "7b51b43ca542958cd2051d6edbe8de3cbe73a5f1ac3e0d8e3c9bff99554f877e"
  end

  # patch to fix incompatible function pointer types, upstream pr ref, https:github.comtmewettBrogueCEpull706
  patch do
    url "https:github.comtmewettBrogueCEcommit3955bcbe9b566a1d18f00c9fcecf9a4aa778ce2b.patch?full_index=1"
    sha256 "8a3b2eb57e420cde266ed760bc004cb13c448b228d2f49b069f3b521bb1d5f5d"
  end

  def install
    system "make", "binbrogue", "RELEASE=YES", "TERMINAL=YES", "DATADIR=#{libexec}"
    libexec.install "binbrogue", "binkeymap.txt", "binassets"

    # Use var directory to save highscores and replay files across upgrades
    (bin"brogue").write <<~EOS
      #!binbash
      cd "#{var}brogue" && exec "#{libexec}brogue" "$@"
    EOS
  end

  def post_install
    (var"brogue").mkpath
  end

  def caveats
    <<~EOS
      If you are upgrading from 1.7.2, you need to copy your highscores file:
          cp #{HOMEBREW_PREFIX}Cellar#{name}1.7.2BrogueHighScores.txt #{var}brogue
    EOS
  end

  test do
    system bin"brogue", "--version"
  end
end