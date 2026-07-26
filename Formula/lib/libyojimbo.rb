class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://ghfast.top/https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "e67e987948fc1513c4f83a60cb7e4c40fdfbc1eebcf6ae9a454f24dcada5dfef"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "26046275ccac5ef45a25bdac2d53c6c36ddade637c4b3e7adde9eef0e767c21d"
    sha256 cellar: :any, arm64_sequoia: "e0a00eb869d09b6920e75b84089a31eba3cc86e35d1885a2c6601acf00ce8c6c"
    sha256 cellar: :any, arm64_sonoma:  "a91424c322eb73bdd9138fac2ef1c7a33546969d8f1488eb09389fe7eb1e9277"
    sha256 cellar: :any, sonoma:        "203cb8cea8a413f4a88b6655c06018ee7ce4526377671d985ad9b76dc8234bd3"
    sha256 cellar: :any, arm64_linux:   "e4f3059f40e5c3b2c2713a5635a37404fa9f5c6636d37ea0a0ef97064c2feaf8"
    sha256 cellar: :any, x86_64_linux:  "bd9bac9e459346033b0004f78bd0b52fc63a2974b59b4fa2bc34d5145d5696b3"
  end

  depends_on "cmake" => :build
  depends_on "libsodium"
  depends_on "netcode"
  depends_on "reliable"
  depends_on "serialize"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DYOJIMBO_SYSTEM_DEPS=ON",
                    "-DYOJIMBO_BUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <yojimbo.h>

      int main() {
        if (!InitializeYojimbo()) {
          return 1;
        }
        ShutdownYojimbo();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lyojimbo", "-o", "test"
    system "./test"
  end
end