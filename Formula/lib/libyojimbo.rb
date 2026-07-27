class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://ghfast.top/https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "3d626a32d260e3600ce7fafca694edb04f39170df17e1e21ffe0d842daa82991"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "10e70b03633291e16267ad8cc2b79c2bf1d840b20081e1ba739c4b06226a2961"
    sha256 cellar: :any, arm64_sequoia: "2c53f875ccc3f6c26fbf5ce1503f5d6d1de709356bb649e81eb8a4619ee21a15"
    sha256 cellar: :any, arm64_sonoma:  "93fe44052b0a0d4b7ea72bb7e0f4c00243e581fb055a464d638f34fb0537b3d0"
    sha256 cellar: :any, sonoma:        "406369360ec0199265c7aef0820d5c08f2260f975e865a0889d45eaf55a2d0d8"
    sha256 cellar: :any, arm64_linux:   "32a4c74a8fffbcde35e6f20064a30563245bfc1b4b47f1042760d6949cad5029"
    sha256 cellar: :any, x86_64_linux:  "178675a61d529ae9a93a1d59981d25f49427ecd30ff2629e60850ae3d1e7413e"
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