class EasyrpgPlayer < Formula
  desc "RPG Maker 20002003 games interpreter"
  homepage "https:easyrpg.org"
  url "https:easyrpg.orgdownloadsplayer0.8easyrpg-player-0.8.tar.xz"
  sha256 "06e6d034348d1c52993d0be6b88fc3502a6c7718e366f691401539d5a2195c79"
  license "GPL-3.0-or-later"
  revision 7

  livecheck do
    url "https:easyrpg.orgplayerdownloads"
    regex(href=.*?easyrpg-player[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a32ab95798e512a5e7aedbf1ed9427fa5b7f61c26e7b9eca46b8ec5309fa52b5"
    sha256 cellar: :any,                 arm64_sonoma:  "a235adad11b54f8cff2742248e2feb77553091870043fbac8f86376c4396df2c"
    sha256 cellar: :any,                 arm64_ventura: "0647aaa793ff98d38f4ab33a51739fd4a38e38b115f3a88c63e9cd750b32e653"
    sha256 cellar: :any,                 sonoma:        "3a0abcf7abbdf8843d99e2a41d29f53b09117d26ca081a5dee9aed20dbd9a7ae"
    sha256 cellar: :any,                 ventura:       "aa01edc79c1b3c6ac0b0ff91e292f5b0e47cbc42149419318a1204b13ea0edc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dd92702f1a18aded2ddebeb9bda83e8f08f46aa78bcb956205bad2315403efc"
  end

  depends_on "cmake" => :build
  depends_on "expat"
  depends_on "fmt"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "icu4c@77"
  depends_on "liblcf"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "mpg123"
  depends_on "pixman"
  depends_on "sdl2"
  depends_on "speexdsp"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "alsa-lib"
  end

  # Add support for fmt 10
  patch do
    url "https:github.comEasyRPGPlayercommita4672d2e30db4e4918c8f3580236faed3c9d04c1.patch?full_index=1"
    sha256 "026df27331e441116d2b678992d729f9aec3c30b52ffde98089527a5a25c79eb"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      prefix.install "buildEasyRPG Player.app"
      bin.write_exec_script prefix"EasyRPG Player.appContentsMacOSEasyRPG Player"
      mv bin"EasyRPG Player", bin"easyrpg-player"
    end
  end

  test do
    assert_match "EasyRPG Player #{version}", shell_output("#{bin}easyrpg-player -v")
  end
end