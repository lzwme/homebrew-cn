class Streamvbyte < Formula
  desc "Fast integer compression in C"
  homepage "https://github.com/lemire/streamvbyte"
  url "https://ghproxy.com/https://github.com/lemire/streamvbyte/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "6c64b1bcd69515e77111df274db9cbc471c5d65cb9769c7b95d3b56941b622dd"
  license "Apache-2.0"
  head "https://github.com/lemire/streamvbyte.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c91d461a760c7f3f1e24f6e89471e25ffdf1d7060ba7c3b1d3a3c8ab5657b29b"
    sha256 cellar: :any,                 arm64_monterey: "63125859b4d53740c682cca73941722d335f4c6acf98eb9c96a9ef10f4d82d9a"
    sha256 cellar: :any,                 arm64_big_sur:  "abb3a56c9e6af35c50b713e05d145e19c0a36fca92d4e68fc19afd4a1166b26e"
    sha256 cellar: :any,                 ventura:        "2812d68567baac71fd240c2c4ef18b3d4e6cad40baadb337c9f779c46c877a38"
    sha256 cellar: :any,                 monterey:       "8539b7a1a74b4cf2d91625eef4490a3451fba6838bc240ebf74c1517b232fe66"
    sha256 cellar: :any,                 big_sur:        "2f3c52073a943d8277dfcdb19315eaca97d713120892c5e5488b08f849188ae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed60a7eee68d7ef8b2009f46b66df9af72ef9a65639d9313d076909904a0d93d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/example.c"
  end

  test do
    system ENV.cc, pkgshare/"example.c", "-I#{include}", "-L#{lib}", "-lstreamvbyte", "-o", "test"
    system testpath/"test"
  end
end