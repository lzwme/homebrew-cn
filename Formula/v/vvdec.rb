class Vvdec < Formula
  desc "Fraunhofer Versatile Video Decoder"
  homepage "https://github.com/fraunhoferhhi/vvdec"
  url "https://ghproxy.com/https://github.com/fraunhoferhhi/vvdec/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "ffdbc137204ca0dd4794c0e90602ce59ab00476f191906a6d110c6ea6655935d"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvdec.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "585404a6b1dee4b141aacc2a3b78a6649346c3347d3231759d64bfcff204a207"
    sha256 cellar: :any,                 arm64_ventura:  "e8f6d5382c68507e5e53dfa75398ce4b8f63fc61dfac018a7cd17cd8b55d927e"
    sha256 cellar: :any,                 arm64_monterey: "d8434ef8ecd9c293c4bd5401676239ac768b7c2e83a3fb86a7330c3aa45f4d9c"
    sha256 cellar: :any,                 sonoma:         "e45eed0ef9270ee837c51a77f7e64c618c59958bcad96450729f0019f14d8cc7"
    sha256 cellar: :any,                 ventura:        "5891055d598db25d649c794e0c10b3c94e113858d622224ff1ddb09ead367d38"
    sha256 cellar: :any,                 monterey:       "785fde6f74380ddce8d83754c365fbb37221243e971cae9447e976c6d7b66613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a09cf16d08b7de4d2c07135dc3223ed702f7d92fe41e02d03e8817ab6f0c37b"
  end

  depends_on "cmake" => :build

  resource("homebrew-test-video") do
    url "https://archive.org/download/testvideo_20230410_202304/test.vvc"
    sha256 "753261009b6472758cde0dee2c004ff712823b43e62ec3734f0f46380bec8e46"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DBUILD_SHARED_LIBS=1",
           "-DVVDEC_INSTALL_VVDECAPP=1",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-test-video").stage testpath
    system bin/"vvdecapp", "-b", testpath/"test.vvc", "-o", testpath/"test.yuv"
    assert_predicate testpath/"test.yuv", :exist?
  end
end