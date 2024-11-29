class Allegro < Formula
  desc "CC++ multimedia library for cross-platform game development"
  homepage "https:liballeg.org"
  url "https:github.comliballegallegro5releasesdownload5.2.10.0allegro-5.2.10.0.tar.gz"
  sha256 "8780b7965ad63646c7c5cd3381c64627e0c1edc3594e0947a7f3696e1176367e"
  license "Zlib"
  head "https:github.comliballegallegro5.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0a49b0d75209741db0980a3dac14dd6451fff9eb8ea9d1852311202a4d343cd2"
    sha256 cellar: :any,                 arm64_sonoma:  "ec50dc855941b5a38481b4b5b24ff581e39407a4a1733d0011a60706cb2ce27b"
    sha256 cellar: :any,                 arm64_ventura: "5462abd33391eaa4487a76853b6b0c3a537398afe54e7db33d16f315b01d2bf3"
    sha256 cellar: :any,                 sonoma:        "ed894015e7b5b1c7db9758ea93c7fd5d836e294681487addaf2538299209a550"
    sha256 cellar: :any,                 ventura:       "5c3dfc3e22f0a035fc52219f842414495f568f2dfc4db638cddba31a0f6db0e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "225eb56faaaf3b624cd63c2f42817083ba9807189bf9cb9dfbcdf37b1d8063fc"
  end

  depends_on "cmake" => :build
  depends_on "dumb"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opusfile"
  depends_on "physfs"
  depends_on "theora"
  depends_on "webp"

  on_macos do
    depends_on "opus"
  end

  on_linux do
    depends_on "jpeg-turbo"
    depends_on "libpng"
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "libxscrnsaver"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    cmake_args = std_cmake_args + %W[
      -DWANT_DOCS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"allegro_test.cpp").write <<~CPP
      #include <assert.h>
      #include <allegro5allegro5.h>

      int main(int n, char** c) {
        if (!al_init()) {
          return 1;
        }
        return 0;
      }
    CPP

    system ENV.cxx, "allegro_test.cpp", "-I#{include}", "-L#{lib}",
                    "-lallegro", "-lallegro_main", "-o", "allegro_test"
    system ".allegro_test"
  end
end