class EasyrpgPlayer < Formula
  desc "RPG Maker 20002003 games interpreter"
  homepage "https:easyrpg.org"
  url "https:easyrpg.orgdownloadsplayer0.8easyrpg-player-0.8.tar.xz"
  sha256 "06e6d034348d1c52993d0be6b88fc3502a6c7718e366f691401539d5a2195c79"
  license "GPL-3.0-or-later"
  revision 4

  livecheck do
    url "https:github.comEasyRPGPlayer.git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "940fa9890761c2e0e6f97823f609b2a86c3d8c132af99041ccd291520ddb4937"
    sha256 cellar: :any,                 arm64_sonoma:   "cb6367f8d7021433cb0777e645c3f2f23b03b78404baac81898c020f799ebc54"
    sha256 cellar: :any,                 arm64_ventura:  "0b918d1a21110b3cc284d7ee0b453cf01cf9d306de3471e5ae868a522ac3ab38"
    sha256 cellar: :any,                 arm64_monterey: "81ddad2d6f50aee5493a461d86c3cef8071d2b4f8186c32cbce7880fbbd7f4ad"
    sha256 cellar: :any,                 sonoma:         "cbccb0b6c47ee38eecc699969f53e963f5edfb34f4290215f829ab501aa24ede"
    sha256 cellar: :any,                 ventura:        "8d136de7c6d891113f50669181ccb5a81e244d6b7b1b63b969ea040379d60210"
    sha256 cellar: :any,                 monterey:       "81a4c9e5b846c151b380ae620192e18cf8db7cebdb34d8d9766e8e96ce3173d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2af54063e4cd34ce5b2a9e1da3c515a464b1029a6fe071307c28a17cab8fc675"
  end

  depends_on "cmake" => :build
  depends_on "expat"
  depends_on "fmt"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "icu4c"
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
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
  end

  fails_with gcc: "5"

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