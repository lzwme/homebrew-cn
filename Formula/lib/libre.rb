class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://ghproxy.com/https://github.com/baresip/re/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "fc92c60d2f624d56abe440ac8dc234958ab0ca04216608da7e07a66c73ea51d5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b25ccdef25fb5aa71f9ed1082943a5e5dc482436901d42b81ce100fedee66f74"
    sha256 cellar: :any,                 arm64_ventura:  "2b9e5e47bef8b77df678bbc1ab31dc579788b415de04f045249f92214dc1103d"
    sha256 cellar: :any,                 arm64_monterey: "65e5fdc9875bc390ac63688d95ad2ca6db2cbedf10fa1cf563a2767d08ff5ac8"
    sha256 cellar: :any,                 sonoma:         "5fc2d7f086c1191d4a75fbfe3446c145952b707c8f988a08f05a8964a81058cb"
    sha256 cellar: :any,                 ventura:        "671d7a1e7aceac92a80a7a514463c958a0d8c25101410a43f14d3e06dd50b06c"
    sha256 cellar: :any,                 monterey:       "783fb581226dd99fe88fa2e5e79373a516840ed8920e9ebffc3a777321887a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a5c3e2a9fc4e795e9c2d7018122f95a290aaf87e53c0e7f6901e0768bdac1bb"
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
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end