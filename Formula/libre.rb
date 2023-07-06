class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://ghproxy.com/https://github.com/baresip/re/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "f5b190b7b4d2721ae6b2873a72534f518a7bb5a2c9571e1e0ff81b42ebd37fd7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fd208a725e742abc9c17e7147cb8436a2ea887c26a1248fa7792955d731f195c"
    sha256 cellar: :any,                 arm64_monterey: "e9f72b4b1b452a55811d0cf805daf81252179d6564a82b36ed8ea2efc8cdc993"
    sha256 cellar: :any,                 arm64_big_sur:  "400be0139ba99273c8fc2cd1d0ee931f90c60ec1dec6c8ecde84865f96f78a9f"
    sha256 cellar: :any,                 ventura:        "e572867793025401973398784c7abdcb8f5dd1c15b5fe0e34f79f7dff9aee516"
    sha256 cellar: :any,                 monterey:       "522abf1465301afa5554ba4b1808f9a6d3b59982726c868379ac69ca44e3bc93"
    sha256 cellar: :any,                 big_sur:        "ef96a296a7deac2609b78e85c15f022bf62473d151a1794fd62fa5abd34a4e7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46100d8be9bb8bfbb526da6aa0163bdadc59d3c9480aee50653d128fbf0b8897"
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