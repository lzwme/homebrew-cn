class Far2lTty < Formula
  desc "Unix TTY port of FAR Manager v2 (with NetRocks support)"
  homepage "https://github.com/elfmz/far2l"
  url "https://ghfast.top/https://github.com/elfmz/far2l/archive/refs/tags/v_2.9.0.tar.gz"
  sha256 "69a5218fcfd072a2d4b99ecac8363a67d85f2fd67b65243f8ea7b239bb134ed0"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(/^v?_?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0c1a7bb67310b6e1eef7b778e8643b318dd6f47c0578ec7fad44ad8573fb2d87"
    sha256 cellar: :any, arm64_sequoia: "9e230ec7c62ccc8901b0e11efa79ff595dc60eb3db9d30ecb784625cd5432f30"
    sha256 cellar: :any, arm64_sonoma:  "73cd40c3dcaa1c0dcf869889fed336f4e0e71863a4c312157fff07d8c4cac47b"
    sha256 cellar: :any, arm64_linux:   "39b8fb5939286174bf2b0c7660a780f2f78a8ee876c06fa7f98feeae55849467"
    sha256 cellar: :any, x86_64_linux:  "74bccd5d5ffd9516d4eaf30839014264931a0ef3cd07a8b37c634f428c2ca4a0"
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