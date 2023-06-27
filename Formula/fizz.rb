class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  # Remove stable block when the patch is no longer needed.
  stable do
    url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.06.12.00/fizz-v2023.06.12.00.tar.gz"
    sha256 "609f053d3b0cd1d1f1ff83852af29e812de66aff2b488e5697f744e4c6f7040d"

    # Fix build failure. Remove in next release.
    patch do
      url "https://github.com/facebookincubator/fizz/commit/0dc415e2e7dade586b445946a939d4f8ff15e8d2.patch?full_index=1"
      sha256 "8d75a960bd1087ed776842fb539f87ec38ed2bad9d18aaea01231172c2386c45"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d39bd0bf31b78d11f4234b365ab8f3f3d6f1943d4e0aa7d54f9030dfa8c639b5"
    sha256 cellar: :any,                 arm64_monterey: "ace9f6699f95fc4a502455cf55eb25490904c13ba745266f51652addf8f9b2f3"
    sha256 cellar: :any,                 arm64_big_sur:  "0c91eb72bdc0ab4d51c304e2f5f4af13fe60458f4e6316c665f2420f0d303f91"
    sha256 cellar: :any,                 ventura:        "b888ac3e099ed80a8a8cb93104416be2aee5fb9c77bbe3308934a4c06a7f5050"
    sha256 cellar: :any,                 monterey:       "0a6befa18948b32d6e99bc5a7c6ab0e2247fc70d5e1a1caa49659e1283fdf997"
    sha256 cellar: :any,                 big_sur:        "4661b87c505c3b51973f82159cdb071e6bf5c9942b4e90d5d7d2f369658f5581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fff73193a0003255c5a668384289d8e0647cd37c7ed4609c2b8470cebd16887a"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "zstd"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", "fizz", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fizz/client/AsyncFizzClient.h>
      #include <iostream>

      int main() {
        auto context = fizz::client::FizzClientContext();
        std::cout << toString(context.getSupportedVersions()[0]) << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfizz",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["gflags"].opt_lib}", "-lgflags",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["libevent"].opt_lib}", "-levent",
                    "-L#{Formula["libsodium"].opt_lib}", "-lsodium",
                    "-L#{Formula["openssl@3"].opt_lib}", "-lcrypto", "-lssl"
    assert_match "TLS", shell_output("./test")
  end
end