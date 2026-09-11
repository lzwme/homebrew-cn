class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://ghfast.top/https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "0ecaa274c91b0072598b6ee319e7093da1b11fe76e524f075c286723b2ef8bf1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e02681faf0be902b312d1169951572996d8be01d8c361351ab9fe9a0e0c23760"
    sha256 cellar: :any, arm64_sequoia: "0c0f08ff1026c74d8e0e35065818006b358186a3f25d2dc286dfa9af078871e4"
    sha256 cellar: :any, arm64_sonoma:  "058804c1e49a97c3f37eca15dba66cd4bc404143e89aa4c61098e72f61d2f431"
    sha256 cellar: :any, arm64_linux:   "082fbec81465deee5c1d5517c34e297d44564ef4a13bcd7174ec9616a7097f76"
    sha256 cellar: :any, x86_64_linux:  "fe0e96a6662ecbff6cfc5b74c98197c1bdeaa6589a68e66ce9d872e054b8cccb"
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