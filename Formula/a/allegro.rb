class Allegro < Formula
  desc "CC++ multimedia library for cross-platform game development"
  homepage "https:liballeg.org"
  url "https:github.comliballegallegro5releasesdownload5.2.10.1allegro-5.2.10.1.tar.gz"
  sha256 "2ef9f77f0b19459ea2c7645cc4762fc35c74d3d297bfc38d8592307757166f05"
  license "Zlib"
  revision 1
  head "https:github.comliballegallegro5.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3b43e0f8503452a10313f09425c881b2904307185834e264d169902ec2211e38"
    sha256 cellar: :any,                 arm64_sonoma:  "d9485d8eb15902bf533254101a297e5f04d44b8fdb3c86bd70cda6d609bdde8d"
    sha256 cellar: :any,                 arm64_ventura: "559055fd2e03e6cd292370bb4a72b838e89f2917a17e152cc1e00a1567232efe"
    sha256 cellar: :any,                 sonoma:        "0a8120e62d0f2f95d57db7d238348b02cf5ba6e23f707d26fb982348c2f49603"
    sha256 cellar: :any,                 ventura:       "4c6e94c6ab57cad68876ed6fc2ddfe02dddfe8499199bfc21542b479762435dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13e7ac2228a2a3f2b975bd5da105c7c63a15b88b76582f5e47510f54f6ad92a0"
  end

  depends_on "cmake" => :build
  depends_on "dumb"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libogg"
  depends_on "libopenmpt"
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