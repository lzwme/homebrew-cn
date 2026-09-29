class Xdelta < Formula
  desc "Binary diff, differential compression tools"
  homepage "https://github.com/jmacd/xdelta"
  url "https://ghfast.top/https://github.com/jmacd/xdelta/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "dc75f6a9615ac278fe00375d94241f47af4e893f11e4a9f46b4ca4e2e1f99e66"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "77c6710de1dd2e54af9581d7d2828a832479d01b1e0771d7025e6fe914c43624"
    sha256 cellar: :any, arm64_tahoe:       "0e1d72580a6a761ba431651efb25d71ba49fa93d8e762c0756b7b75dbbdf9e35"
    sha256 cellar: :any, arm64_sequoia:     "8ae2b737241d27f9aa909f418629c1cedb6006d888100a4d13623e16bb6613e1"
    sha256 cellar: :any, arm64_linux:       "ab12a1403ff1fab874d446fb9f48e20e776b66a50189bf5287e6521b0f5a1f4a"
    sha256 cellar: :any, x86_64_linux:      "be2365a878dd108cbdfd86958918c041be2f48de33be0a9d58a3989b6dd9f2a6"
  end

  depends_on "cmake" => :build
  depends_on "blake3"
  depends_on "xz"

  deny_network_access!

  def install
    # Fix library target to the same as `blake3` formula.
    inreplace "xdelta3/CMakeLists.txt",
              "set(XD3_ARMOR_LIBRARIES blake3)",
              "set(XD3_ARMOR_LIBRARIES BLAKE3::blake3)"

    args = %w[
      -DXD3_BUILD_TESTS=OFF
      -DXD3_LZMA_MODE=on
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
    ]
    system "cmake", "-S", "xdelta3", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"xdelta3", "config"
  end
end