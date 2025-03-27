class Libre < Formula
  desc "Toolkit library for asynchronous network IO with protocol stacks"
  homepage "https:github.combaresipre"
  url "https:github.combaresiprearchiverefstagsv3.21.0.tar.gz"
  sha256 "ef4327eb46167bf91e91d2cf56214244d7c57b401f0f170a7cef7c1d65b48228"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f9f11dc49026e22538bf6c13b9ebeb2c6d854938c9e95e4483b489db261b7269"
    sha256 cellar: :any,                 arm64_sonoma:  "c892878b6aeaa23d177a7e88fc2c31f91f7748a5343d1cfabb3663f083b736d5"
    sha256 cellar: :any,                 arm64_ventura: "89d973870b76bfe5c1ad5786246a1b74e5b84581fe6762ab816457a79d1571f5"
    sha256 cellar: :any,                 sonoma:        "38bd0db3b838c2a190f2823ee84aedfdc6319638f5e1db4a520c2afd67f0696f"
    sha256 cellar: :any,                 ventura:       "b3decc266970ead082b233be2c25affcaeb2d26dc602c9e367ab035e58c0aa53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aa5a6ec1626a66c8880b6df4ecab71ef89f577e28d70785c76cf75051c6f892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14f8fcb84dc6b8218942274225f9fa54a50b5362c304a1f9a58bb78de960ec20"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdint.h>
      #include <rere.h>
      int main() {
        return libre_init();
      }
    C
    system ENV.cc, "-I#{include}", "-I#{include}re", "test.c", "-L#{lib}", "-lre"
  end
end