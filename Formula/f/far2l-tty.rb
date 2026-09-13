class Far2lTty < Formula
  desc "Unix TTY port of FAR Manager v2 (with NetRocks support)"
  homepage "https://github.com/elfmz/far2l"
  url "https://ghfast.top/https://github.com/elfmz/far2l/archive/refs/tags/v_2.9.0.tar.gz"
  sha256 "69a5218fcfd072a2d4b99ecac8363a67d85f2fd67b65243f8ea7b239bb134ed0"
  license "GPL-2.0-only"
  revision 3

  livecheck do
    url :stable
    regex(/^v?_?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "735de8e6193e2027c84910d8a3755d2c7385e0d867cbd806bba5dbdb216c490e"
    sha256 cellar: :any, arm64_tahoe:       "5c9d198b0d931288b1bc7518225822a3ae44ed6498ee4100dc4382656867e864"
    sha256 cellar: :any, arm64_sequoia:     "fdb1c8b9786f145f25ffa39a3aa378669f904ae55d4769e317371f6181421fc0"
    sha256 cellar: :any, arm64_linux:       "5f989d399dffe06e02f299622477c8475707c74bb09e75df9e8dde23d28402ee"
    sha256 cellar: :any, x86_64_linux:      "58a78d31da627f4cfe642c530e65659a92ba5e0a81ba9b80bff68e5b7877893c"
  end

  depends_on "cmake" => :build
  depends_on "gperf" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libarchive"
  depends_on "libnfs"
  depends_on "libssh"
  depends_on "neon"
  depends_on "openssl@3"
  depends_on "uchardet"

  uses_from_macos "m4" => :build
  uses_from_macos "libxml2"

  def install
    args = %w[
      -DUSEWX=OFF
      -DUSESDL=OFF
      -DTTYX=OFF
      -DNETROCKS=ON
      -DNR_AWS=OFF
      -DNR_SMB=OFF
      -DMULTIARC=ON
      -DPYTHON=OFF
      -DCOLORER=ON
    ]

    system "cmake", "-S", ".", "-B", "build", "-GNinja", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # This is a TUI application, better tests are not possible
    assert_match version.to_s, shell_output("#{bin}/far2l --version")
    assert_match(/tty/i, shell_output("#{bin}/far2l -h 2>&1"))
  end
end