class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.11.0.0/Allure-0.11.0.0.tar.gz"
  sha256 "6125cc585e2a5f28c88855c3c328385c1f21bed093d7606478f1b2af0cb2b6d6"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", "Bitstream-Vera"]
  revision 6
  head "https://github.com/AllureOfTheStars/Allure.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "61cba6892d9547217707836e07fbd58bbedc09cd0c3de66ec702f964498d6967"
    sha256 cellar: :any, arm64_sequoia: "056f80e8ac29218c32ef605f7f3b26382f3389727152346b6a349a843bfeb574"
    sha256 cellar: :any, arm64_sonoma:  "73fe9005468d96afa4a855f1f2ff085adea986d23e6eab9a6361ebf289a6fa53"
    sha256 cellar: :any, sonoma:        "1e8dfe00d23852d9bc37d5527a37156e45be96cd209fda6b18dc97e25c5c5911"
    sha256 cellar: :any, arm64_linux:   "d67c6fae3b45680f2890399d1c0a47510d6127845b063d148a9b6ea0a896660b"
    sha256 cellar: :any, x86_64_linux:  "1cec1322a97b3a49e02659a8d3a315441cc628911c247f68f21403fff73cc2bd"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "sdl2-compat"
  depends_on "sdl2_ttf"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_empty shell_output("#{bin}/Allure --dbgMsgSer --dbgMsgCli --logPriority 0 --newGame 3 " \
                              "--maxFps 100000 --stopAfterFrames 50 --automateAll --keepAutomated " \
                              "--gameMode battle --setDungeonRng \"SMGen 7 7\" --setMainRng \"SMGen 7 7\"")
    assert_empty (testpath/".Allure/stderr.txt").read
    assert_match "Client FactionId 1 closed frontend.", (testpath/".Allure/stdout.txt").read
  end
end