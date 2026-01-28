class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "https://tigervnc.org/"
  url "https://ghfast.top/https://github.com/TigerVNC/tigervnc/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "10512fc0254ae3bde41c19d18c15f7ebd8cd476261afe0611c41965d635d46e8"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8db6b19fae3c874b8c4fd1cb1c1a30691feaa3a85fde9f5c83347a9e67fef45a"
    sha256 cellar: :any, arm64_sequoia: "9ab2f892c5b11e6fcb9adeeca3f450c617bca800bb4d1e37328636731124871d"
    sha256 cellar: :any, arm64_sonoma:  "c085c867fad3f61d7b6ebde6dcaf621573917bbb1b92b47d5e89f7167598ec26"
    sha256 cellar: :any, sonoma:        "6fb4e06ae703bf7d04a7ce6289d268367261e07208b9a464bd72a38e46a64fd1"
    sha256               arm64_linux:   "b2ec5f88e5d51eec6bcbbc662a4631d290e4f974e66377685ecfcbb36dc4a778"
    sha256               x86_64_linux:  "e002e20fcb339a14997b6cbfc745dfa9b6c6c214bc09fabef07f3a3c97e288e8"
  end

  depends_on "cmake" => :build
  depends_on "fltk@1.3" # fltk 1.4 issue: https://github.com/TigerVNC/tigervnc/issues/1949
  depends_on "gettext"
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "jpeg-turbo"
  depends_on "nettle"
  depends_on "pixman"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxdamage"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxft"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxtst"
    depends_on "linux-pam"
  end

  def install
    turbo = Formula["jpeg-turbo"]
    args = %W[
      -DJPEG_INCLUDE_DIR=#{turbo.include}
      -DJPEG_LIBRARY=#{turbo.lib}/#{shared_library("libjpeg")}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/vncviewer -h 2>&1", 1)
    assert_match(/TigerVNC v#{version}/, output)
  end
end