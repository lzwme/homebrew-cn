class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://ghproxy.com/https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 11

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "0ff626eaa643838cf181a19b1ece74ce5cff6ecda33e38ec982c3c5c342c6555"
    sha256 cellar: :any,                 arm64_monterey: "602f8188ad9cb2eb6348b0ed5e92ea0d2e777596ffc6e494c415b086892e22b4"
    sha256 cellar: :any,                 arm64_big_sur:  "49b2b573006e0ba4e5cac0be4c286694c588d1e1a0e74d87f8ce7a233ce22bcf"
    sha256 cellar: :any,                 ventura:        "5e18029073704eb4eea3392f1f93e191a3a32d5b63d28336587783b3a708a6d5"
    sha256 cellar: :any,                 monterey:       "be3cc4c5df0a0ee2020c7b3c43ca019467595d6781afa713b1ca733e3750fc95"
    sha256 cellar: :any,                 big_sur:        "3c6338c4075b3c89c7bfd71c210d5cdec5a4ceb26b2f58af2aec86bb176c34e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddcfba9bb72f05e72ee9e123c21bbc42b1282f078dca3c066b3611c774c1e650"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "capstone"
  depends_on "protobuf"
  depends_on "re2"

  # Support system Abseil. Needed for Protobuf 22+.
  # Backport of: https://github.com/google/bloaty/pull/347
  patch do
    url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/86c6fb2837e5b96e073e1ee5a51172131d2612d9/bloaty/system-abseil.patch"
    sha256 "d200e08c96985539795e13d69673ba48deadfb61a262bdf49a226863c65525a7"
  end

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"
    # Remove vendored dependencies
    %w[abseil-cpp capstone protobuf re2].each { |dir| (buildpath/"third_party"/dir).rmtree }
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(/100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL/,
                 shell_output("#{bin}/bloaty #{bin}/bloaty").lines.last)
  end
end