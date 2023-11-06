class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://ghproxy.com/https://github.com/baresip/re/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "79bdaa1c2b125b7e6743a8950c6f199ac1aac8f7747ed76ef6b1ee00787502fb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1f6991a3d5c0faaeeda71679a3990fe88c952b20c17cc97aca3093a38343707a"
    sha256 cellar: :any,                 arm64_ventura:  "b89a243333d8ff8c55c7b6521dcbf6ff6381e2bf286b6137bfbddbfbb27d9053"
    sha256 cellar: :any,                 arm64_monterey: "f77781967320c5041e72501475cb76f2ddf2cb76f28fe160eddfbf4f829b8d2e"
    sha256 cellar: :any,                 sonoma:         "ebaac31d85760faa1280332223eba3ad612d32ed8a1f538d619ec8b7c28f92a1"
    sha256 cellar: :any,                 ventura:        "077411f64df642ebf291535d366e0aa0322d8af36887478ffff2a1a7750fae5f"
    sha256 cellar: :any,                 monterey:       "671fc365e915a91905065225542918625aa66d2dad8a12478f6dd0a7356c15ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa4ae07582a49794e7f4313589c4485ba4770c05b66c362a92bcde609a2913e8"
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