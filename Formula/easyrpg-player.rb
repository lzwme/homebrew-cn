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
    sha256 cellar: :any,                 arm64_ventura:  "b5f60a071cc164e97ce7e34bf1ed543fcc5a674769ffffdb5a3f332e685ba8fe"
    sha256 cellar: :any,                 arm64_monterey: "4d179e8a8f94c5825d34fb7adf79d4b11f32fc11bedaa56eca26dcaece139bc0"
    sha256 cellar: :any,                 arm64_big_sur:  "409ba15cc3cae63e5a758df9e87c531b83bc91036b9d46a7c0eafd1693898bb3"
    sha256 cellar: :any,                 ventura:        "79bf9bff929c30f1e7f409075682c49ec4868316519942b16db73d0bd472bec2"
    sha256 cellar: :any,                 monterey:       "b4713e6086b8b563dabe8b6611d86ce03b13505e5bb89b9306e16da41c3ad2bc"
    sha256 cellar: :any,                 big_sur:        "4580e638ac64d0322d50852e88cb56c451d5095b0eded9d7f1e1967d6b2bdff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b21f6dfa5eed3b6f9fe57aa1f47c8f23311fb99fbf5217f84acb3bfb65cd1f49"
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