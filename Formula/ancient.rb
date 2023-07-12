class Ancient < Formula
  desc "Decompression routines for ancient formats"
  homepage "https://github.com/temisu/ancient"
  url "https://ghproxy.com/https://github.com/temisu/ancient/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "7fde64be49e52ce5abc8804d3df13ba1475db0c0bb0513ae50d518e25e76373a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "156cfa56cc3d5896f2d501deaa9e45a9b92070830b69bc36557ef81aa010d7b8"
    sha256 cellar: :any,                 arm64_monterey: "27a37a18f2b5dcc369f2c55648fc7032211b3f9af234f2960ab63674fe2551ea"
    sha256 cellar: :any,                 arm64_big_sur:  "6add15c24d3c41d94a37b170884ac99f7e82eec1a227e0b58c9eca90cb1404db"
    sha256 cellar: :any,                 ventura:        "bcb63492cd0db005e5e5af0c851b50ae63114a2ecaef6ca421031e8443854c54"
    sha256 cellar: :any,                 monterey:       "ab7f801ad71de1ca8b78281b56a25cedd752a70aec39db015bf65a6fdc5e7b25"
    sha256 cellar: :any,                 big_sur:        "44eeba80fb85757ee3c19afa4841a09dfa2067bf483617ad6a8c46e2fa7d6af8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "307d7d4bc49e800df179298c2acd383bf57509fd8c54577f0c6f8086c6a6fb03"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ancient/ancient.hpp>

      int main(int argc, char **argv)
      {
        std::optional<ancient::Decompressor> decompressor;
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-lancient", "-o", "test"
    system "./test"
  end
end