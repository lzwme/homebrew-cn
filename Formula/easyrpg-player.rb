class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.8/easyrpg-player-0.8.tar.xz"
  sha256 "06e6d034348d1c52993d0be6b88fc3502a6c7718e366f691401539d5a2195c79"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/EasyRPG/Player.git"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "daf3194b9fb0faf64947860097982a4a03841819d6e9ea4afa4ecd71b323e27a"
    sha256 cellar: :any,                 arm64_monterey: "b953323513690c47920e192e575dd5847f44f49ea9821b5928a8207918d521a8"
    sha256 cellar: :any,                 arm64_big_sur:  "cff011aef429ea281badad54e791f79505b25e5b28795b0ba4db6620cd30806f"
    sha256 cellar: :any,                 ventura:        "6c4804859c0e8dc89039930e64295008efd2e4074d4928176b26e3191608dc58"
    sha256 cellar: :any,                 monterey:       "d9d6b57ccd033bb6f65946d814175f755115476402337808d70e00e9b8c38c6a"
    sha256 cellar: :any,                 big_sur:        "d29d26279355a33c59f81c756d052b167c091c3bf13640a186633f236f25225c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ff212f9a4eb4a3794d7231902d0c369fc81ad5d7b7d92dd1f951434326a20f3"
  end

  depends_on "cmake" => :build
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

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
  end

  fails_with gcc: "5"

  # Add support for fmt 10
  patch do
    url "https://github.com/EasyRPG/Player/commit/a4672d2e30db4e4918c8f3580236faed3c9d04c1.patch?full_index=1"
    sha256 "026df27331e441116d2b678992d729f9aec3c30b52ffde98089527a5a25c79eb"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      prefix.install "build/EasyRPG Player.app"
      bin.write_exec_script "#{prefix}/EasyRPG Player.app/Contents/MacOS/EasyRPG Player"
      mv "#{bin}/EasyRPG Player", "#{bin}/easyrpg-player"
    end
  end

  test do
    assert_match(/EasyRPG Player #{version}/, shell_output("#{bin}/easyrpg-player -v"))
  end
end