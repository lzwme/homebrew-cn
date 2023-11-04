class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://ghproxy.com/https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 19

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e44107f9826c174f18ad1b2531401dcc7fab6778275502d91bbd94133e01dd54"
    sha256 cellar: :any,                 arm64_ventura:  "74e296002d2860c9ba8a4ce110aba63651071abe3d78048b8d0825c9a39bf97d"
    sha256 cellar: :any,                 arm64_monterey: "ec8edad62676bc9d64833f28988e15075b4902526e190e425dd99167fee0bd4e"
    sha256 cellar: :any,                 sonoma:         "c3fdc19ed423e2bed95d0333024097716d990fb43c98295f1fc11dae5ec8494c"
    sha256 cellar: :any,                 ventura:        "bba16d22e71945ddf8eb32c29b445aea27a40ab395196a9927365a25e9403aa8"
    sha256 cellar: :any,                 monterey:       "8a863a40544af444e4618dcd665dc6cda7077be74b4f1a6ed0e72d91ec51745e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "578b9fcbf9c32481fe95f0b07a1afc53cdc5befcf2f540212fe2caa73969d04a"
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