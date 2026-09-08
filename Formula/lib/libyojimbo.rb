class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://ghfast.top/https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "746fedba859dfe720b6cb79f802f56f046d782566c0a67f111ef100eb60130f1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "678a46d93c4f51b1881c647dafc914cdb7ad1b89a3e944fe0f35fac693118d5f"
    sha256 cellar: :any, arm64_sequoia: "eb01cbbfb9167df1a2f22660ec72f7d5c436836d864faa21aca7afebc2414dd1"
    sha256 cellar: :any, arm64_sonoma:  "f77528e4cc06ed3dacdba8d689db979ee0bb4788b5f4c0fc0173e7e383661d95"
    sha256 cellar: :any, arm64_linux:   "69e738b74ab3c1f64ac5899419ce27800677e467e6d91c0cecf9a7ba33e389bc"
    sha256 cellar: :any, x86_64_linux:  "2aad7e2dc4ab2a6d7196836d209ec6b1ab01f488ed3dd6dea0b0d936abe8878f"
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