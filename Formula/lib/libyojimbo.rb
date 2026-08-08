class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://ghfast.top/https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "34389a5726ab95da84a764d791d7981ee45c0babc1ee4852e365b80c8ba788c8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1a8f2c2a8eab415becd1efd59402aac29063795a01ce2eb85b4e4d1134ddc7ee"
    sha256 cellar: :any, arm64_sequoia: "4cfa9aeb87c8670621a596cbd7c7a75198e580920610d6fc220c4442f27abd2d"
    sha256 cellar: :any, arm64_sonoma:  "3528421ed27cdf5b3aad2d55a9c6c42d153c7de44e83cc8be05757ef8462a2af"
    sha256 cellar: :any, sonoma:        "f3fe3e987230a87e84b46534f004327b9e37866adc340dfb289a1fa674f015a7"
    sha256 cellar: :any, arm64_linux:   "4075b941681e8d2da7b79cb92a4e1ce667935ab9443d589557c9372e00f27f31"
    sha256 cellar: :any, x86_64_linux:  "0b073afb73992c066505b2c9db2933f8025e51e583c840745590b3824a69d168"
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