class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://ghfast.top/https://github.com/baresip/re/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "db60a89641c39092269c77fdb6340bb8f6292c3a2f807a1446a694fd16cdd81d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c8e15cf1a65fa4a4a15dd107e599d5011d2506a261f3a0215cef6593b9e1fc1c"
    sha256 cellar: :any,                 arm64_sequoia: "2e5bcfcf528bd2673b4b21a82e83c6dc7b1d35a41759fdc38b0a69d713a58515"
    sha256 cellar: :any,                 arm64_sonoma:  "5a6bcfe3b2ef554e41e753a13133a221850025c0cbb0615112c43e49e60e5600"
    sha256 cellar: :any,                 sonoma:        "84175e2c3751968e10a4ef90a9f5c14ff32d9b100ec3b18476498ff29fc64603"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8087a233f7028d5b0cf0c6876f01fce3e20c40bbbc7cdf7b6c6d3fce02164731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c096b569676c6ad010c13bf829b4a24803448e291135a14d4b7455a31ba56b6a"
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
    (testpath/"test.c").write <<~C
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    C
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end