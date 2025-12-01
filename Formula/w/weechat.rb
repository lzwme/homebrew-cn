class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.8.0.tar.xz"
  sha256 "ed28dca2ab11b41c041df61533ad8b473c3ebf3544a1991ad43d08cfa66fe165"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "3deaff50495dd1917559acbdb71e1600c3ee10c7ea0aa7073a42225e10712d21"
    sha256 arm64_sequoia: "1e27354c0705d07ccfc0cce9551e7beed2c6c629b5b177d377bd0fe682cc8fa0"
    sha256 arm64_sonoma:  "9b97b5769f8855e53d34c13e5a5a067086c04da6a0c060ad635bed9e358e4174"
    sha256 sonoma:        "234504ba153ababf206cc76f7b0a9f5a726dca66263a5c2ad310cd63fcbf9958"
    sha256 arm64_linux:   "98295aba7e86a2761fbe1624051755052d626e80224f837927408b2f97a5a86f"
    sha256 x86_64_linux:  "e9880f3a85bd09928a102fdb8e2996556464ae1b91c58f02fa9a59bd5de036f0"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "gettext" => :build # for xgettext
  depends_on "pkgconf" => :build
  depends_on "aspell"
  depends_on "cjson"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.14"
  depends_on "ruby"
  depends_on "tcl-tk"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "libgpg-error"
  end

  def install
    tcltk = Formula["tcl-tk"]
    args = %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{Formula["gnutls"].pkgetc}/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
      -DTCL_INCLUDE_PATH=#{tcltk.opt_include}/tcl-tk
      -DTCL_LIBRARY=#{tcltk.opt_lib/shared_library("libtcl#{tcltk.version.major_minor}")}
      -DTK_INCLUDE_PATH=#{tcltk.opt_include}/tcl-tk
      -DTK_LIBRARY=#{tcltk.opt_lib/shared_library("libtcl#{tcltk.version.major}tk#{tcltk.version.major_minor}")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"weechat", "-r", "/quit"
  end
end