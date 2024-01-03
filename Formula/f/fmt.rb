class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https:fmt.dev"
  url "https:github.comfmtlibfmtarchiverefstags10.2.0.tar.gz"
  sha256 "3ca91733a7313a8ad41c0885929415f8ec0a2a31d4dc7e27e9331412f4ca26ac"
  license "MIT"
  head "https:github.comfmtlibfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "66982226cb5352d15e01d17247b0b5da9682a0989fad58f17b2eb49de0fe29ca"
    sha256 cellar: :any,                 arm64_ventura:  "14e5307768db3df98e5ae73b169a678d3bf2edbf8c60faa7738dc27fdc611e61"
    sha256 cellar: :any,                 arm64_monterey: "52909c5356df6bf05e3e0c5481327466119048652ea2721a36d953b6246906e1"
    sha256 cellar: :any,                 sonoma:         "3894f5fa4cfe1d5197e3cf3cb598a7bed0ef4401d0245e9a244849eb8c47082b"
    sha256 cellar: :any,                 ventura:        "18c0f5d79990478ec65da28d60389c293ab50241a000876356aa36b480e14e47"
    sha256 cellar: :any,                 monterey:       "46fcb7a99298fb2c32b2882d46c1c5d662fc1121f4ff6afee8cadfc8a9b4f813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1d8ab6b8362b9d6174492009c7b86c7ac917d42c5d6fe14cf35084b0f4982ad"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-staticlibfmt.a"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <fmtformat.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output(".test")
  end
end