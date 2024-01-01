class Libre < Formula
  desc "Toolkit library for asynchronous network IO with protocol stacks"
  homepage "https:github.combaresipre"
  url "https:github.combaresiprearchiverefstagsv3.8.0.tar.gz"
  sha256 "93bcfc71abed724e1d185a24d37fa88f6f8c6597ad11e72d1d251a00ce0abe85"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4b538146761999554efe1308aac5c3f124df86c4c6134623f6be338c6111264f"
    sha256 cellar: :any,                 arm64_ventura:  "4415d2704cb63d4bb41b8fd05300ec453bdba0305d0a7e12cbf457c8895ed277"
    sha256 cellar: :any,                 arm64_monterey: "e6924c8643442e25b359fd2223699d185252782487f41110b4aba3157a37b86c"
    sha256 cellar: :any,                 sonoma:         "fa67b69e9a9954f9e9a92d564bc2a0e5a437fddc1ca62a20c7587610944fbc61"
    sha256 cellar: :any,                 ventura:        "f1802c1638a3a9dfcf29b374d51a49cf749fe2f1aacc35b5253a2dc87e916fbd"
    sha256 cellar: :any,                 monterey:       "d28c6a48c088d919d7d8d4a91263bd2ef1633b9a4b1af53d5c973466c48a22a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35e902cfdea9cc72de7e513c0646958502196c649850f523d3bd7a6cbaf3bd81"
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
    (testpath"test.c").write <<~EOS
      #include <stdint.h>
      #include <rere.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{include}re", "test.c", "-L#{lib}", "-lre"
  end
end