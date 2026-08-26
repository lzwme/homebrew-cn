class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://ghfast.top/https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "c4753d946032af1507c161392b357eaf7232ed94f500f953a32be34dc0fadc9d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c24df23be3517f536a750b7724caf09b588d6bdb13253967ba029cc316a8bffa"
    sha256 cellar: :any, arm64_sequoia: "147fce1758b643bc5a451da469eefe1192b928fec96145484db0af5a64187bdc"
    sha256 cellar: :any, arm64_sonoma:  "9bbc12a8884cfa52b0041ec0527be272bff309bd0f8031d06417230ffbb2ecb3"
    sha256 cellar: :any, sonoma:        "e874c36dace4177f7d53d78347b40d77acdb4d19e728a744da5bb58cc2391d0a"
    sha256 cellar: :any, arm64_linux:   "e2841542a41a0cb58e13b39208f7b5cedde273e8bdcea3543caaf06cf28d780a"
    sha256 cellar: :any, x86_64_linux:  "7adec037c7246eddc89c2cba46620a2c2ddcaf9f5659581ad9af71274168813f"
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