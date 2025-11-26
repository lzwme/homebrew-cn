class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://ghfast.top/https://github.com/liballeg/allegro5/releases/download/5.2.11.0/allegro-5.2.11.0.tar.gz"
  sha256 "4d06a8c8bf7afc91b304f1b12a114afba9d8a7413357c2a3579528d45a8f3d6b"
  license "Zlib"
  head "https://github.com/liballeg/allegro5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a081a8c2d30674fa6237103ac52045707bd7d5c10d05952ae7985882947295e8"
    sha256 cellar: :any,                 arm64_sequoia: "8dfe8952b79782a244428e769b8b5b0a7e3d7f8a23eeb92a300700ca83f8f0c0"
    sha256 cellar: :any,                 arm64_sonoma:  "7ac94dfe962a1d545eea6f8fe0f63f0d54795037228766080ca7123ee40ba95f"
    sha256 cellar: :any,                 sonoma:        "94ceb581d2cea861a940717d4f91248a4c0aab77987affc1a479d162da252ed3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3dc016b4d89b3cbbcc9eb1b2cacce8cfb9f8c5ccf501a7885d328e1ad8d5eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8988d0214db349ecd93ed900db859e88d63f5de556ad58646f9af6beb2d61ceb"
  end

  depends_on "cmake" => :build
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
    cmake_args = %W[
      -DWANT_DOCS=OFF
      -DWANT_DUMB=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"allegro_test.cpp").write <<~CPP
      #include <assert.h>
      #include <allegro5/allegro5.h>

      int main(int n, char** c) {
        if (!al_init()) {
          return 1;
        }
        return 0;
      }
    CPP

    system ENV.cxx, "allegro_test.cpp", "-I#{include}", "-L#{lib}",
                    "-lallegro", "-lallegro_main", "-o", "allegro_test"
    system "./allegro_test"
  end
end