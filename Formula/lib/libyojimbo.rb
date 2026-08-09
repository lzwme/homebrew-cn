class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://ghfast.top/https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "9ab6292a277a4af7882221337cc24e5c5802076b0f1886b85eff5b15a4cc872b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4ac5631a2ea77f840f89cf63a0c52fd538160c3fddaae18fbfb42b787337ee1d"
    sha256 cellar: :any, arm64_sequoia: "ede4734891409bdb53d2edd8936a23e5cf94be281fd3d122121a713fee12ac44"
    sha256 cellar: :any, arm64_sonoma:  "88328a25d69b0d867d7e80396ee296b61674365cb43366c81aad3bc3b235ce98"
    sha256 cellar: :any, sonoma:        "a6a20fcf6a389900d573efe87e1867eeda2699eae2854e10f983f2a2bbe99bd7"
    sha256 cellar: :any, arm64_linux:   "3386ce485989aada1faf91d1ae63764d727ae6f6ce8f69ba825d2db70325d03b"
    sha256 cellar: :any, x86_64_linux:  "42969acd0fd713181234ec9016c2449d8a3b46a6969ff88ba3aea303d1ce891e"
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