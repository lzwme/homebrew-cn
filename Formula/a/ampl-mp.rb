class AmplMp < Formula
  desc "Open-source library for mathematical programming"
  homepage "https:ampl.com"
  url "https:github.comamplmparchiverefstagsv4.0.2.tar.gz"
  sha256 "12b01027392bb1b657d43de3785dd33d6fd83b2e9a6c3190d6c670c844050290"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d16d465e947201a4a899c32a2bcebe0b7c0d01b3cd75a90e22be090c72ca99f4"
    sha256 cellar: :any,                 arm64_sonoma:  "a2cdd6391aa7bed8a31de72b663cb4330400a6de125ecf3952e81118fda96775"
    sha256 cellar: :any,                 arm64_ventura: "5bac1dd2f1ece8673455369d939542547419e7539a473a6158d0a137372659d7"
    sha256 cellar: :any,                 sonoma:        "4d587a2d6d846dc717ed1011ffa314c41a248745d79a9d89374e94158d194f00"
    sha256 cellar: :any,                 ventura:       "8a679cea3a7e0afbb132275170537c467cfaad703a05b3b4c9f3b0f99018312b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eef9468a675fd50f947dc34c3f6872f1c33ad7a003af567fcf1c26adccc89523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0baaeab25d92212b75ea817115aa2186adf0b19dadad895e8c9abd86440ba5c1"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DAMPL_LIBRARY_DIR=#{libexec}bin
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: libexec"bin")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include "mpampls-c-api.h"

      int main() {
          AMPLS_MP_Solver* solver = (AMPLS_MP_Solver*)malloc(sizeof(AMPLS_MP_Solver));
          free(solver);
          return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}mp", "-L#{lib}", "-lmp", "-o", "test"
    system ".test"
  end
end