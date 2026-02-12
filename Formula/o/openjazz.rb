class Openjazz < Formula
  desc "Open source Jazz Jackrabit engine"
  homepage "https://www.alister.eu/jazz/oj/"
  url "https://ghfast.top/https://github.com/AlisterT/openjazz/archive/refs/tags/20240919.tar.gz"
  sha256 "c50193b630c375840026d729bb9dda6c7210b1523e62d7ae019ce2e37f806627"
  license "GPL-2.0-only"
  head "https://github.com/AlisterT/openjazz.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "bc2094b29109b45a5eb6ae8a371497d725561aae932718ff4d051cd99318d3b7"
    sha256 arm64_sequoia: "2b3e94c863d4274b62301bd23d3be3ff1178080b4e8d6e009c79b6ca21b0f71c"
    sha256 arm64_sonoma:  "3bbaed46d4ff6ed830405c129fa0bf7c1af5849ffbdfae0bd06f21e8c90fa774"
    sha256 sonoma:        "49f6764a2ade0727fbbcab9785c8c1c6e7e5fd975325115ed2425a1a7ffbecb2"
    sha256 arm64_linux:   "aa661bad9d6a7343909105993e09393ea87da33cd18c2a3d8f39d658014f2403"
    sha256 x86_64_linux:  "e11ba77658b99c4844292e2656ac702c350419cbe7fbf0c3564b2d150a1a73de"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"
  depends_on "sdl2_net"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # From LICENSE.DOC:
  # "Epic MegaGames allows and encourages all bulletin board systems and online
  # services to distribute this game by modem as long as no files are altered
  # or removed."
  resource "shareware" do
    url "https://image.dosgamesarchive.com/games/jazz.zip"
    sha256 "ed025415c0bc5ebc3a41e7a070551bdfdfb0b65b5314241152d8bd31f87c22da"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DDATAPATH=#{pkgshare}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    resource("shareware").stage do
      pkgshare.install Dir["*"]
    end
  end

  def caveats
    <<~EOS
      The shareware version of Jazz Jackrabbit has been installed.
      You can install the full version by copying the game files to:
        #{pkgshare}
    EOS
  end

  test do
    system bin/"OpenJazz", "--version"
    assert_path_exists testpath/"openjazz.log"
  end
end