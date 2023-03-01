class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "https://www.raylib.com/"
  url "https://ghproxy.com/https://github.com/raysan5/raylib/archive/4.2.0.tar.gz"
  sha256 "676217604a5830cb4aa31e0ede0e4233c942e2fc5c206691bded58ebcd82a590"
  license "Zlib"
  head "https://github.com/raysan5/raylib.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "ec67c3221fb300294d3c643e6b034713b95e63771279aa6e380b7e1c8e717614"
    sha256 cellar: :any,                 arm64_monterey: "01236d25f3d11ed06e4f3879475af7a682c4607447e90741a889a91663d43852"
    sha256 cellar: :any,                 arm64_big_sur:  "57b7d7a99f53062c93a8c4bbb8dfd4e0616b99cf2568c881b407b9a225026ceb"
    sha256 cellar: :any,                 ventura:        "d5831b9563d8472813c775c76ef9ee4ff4d8f25dc0ef5060f2846b9fee0ddfeb"
    sha256 cellar: :any,                 monterey:       "b006fe2ac760039dbeaff35b6b4ca3efd0400c1bc96721b1f6a20f7bb47a7d13"
    sha256 cellar: :any,                 big_sur:        "4ae7529ca36e3472288580111ad74e8f8ef25dd261c12da9deabf096cf5b363a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00df3ed5cda42486632e8016d127862f00e69685c5944401cce87d3cc523584e"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                               "-DBUILD_SHARED_LIBS=ON",
                               "-DMACOS_FATLIB=OFF",
                               "-DBUILD_EXAMPLES=OFF",
                               "-DBUILD_GAMES=OFF",
                               *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build-static",
                               "-DBUILD_SHARED_LIBS=OFF",
                               "-DMACOS_FATLIB=OFF",
                               "-DBUILD_EXAMPLES=OFF",
                               "-DBUILD_GAMES=OFF",
                               *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/raylib/libraylib.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <raylib.h>
      int main(void)
      {
          int num = GetRandomValue(42, 1337);
          return 42 <= num && num <= 1337 ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS
    flags = if OS.mac?
      %w[
        -framework Cocoa
        -framework IOKit
        -framework OpenGL
      ]
    else
      %w[
        -lm
        -ldl
        -lGL
        -lpthread
      ]
    end
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lraylib", *flags
    system "./test"
  end
end