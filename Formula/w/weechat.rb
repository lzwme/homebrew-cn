class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.8.1.tar.xz"
  sha256 "e7ac1fbcc71458ed647aada8747990905cb5bfb93fd8ccccbc2a969673a4285a"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/weechat/weechat.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "caa09090afceb487fda3fe7edacf02d69329de41944b5bab0f2d4cf9b7e6342b"
    sha256 arm64_sequoia: "55352c8a0be93045ac4731d76f9fa934936685de56fe26761c98d6fe933201fb"
    sha256 arm64_sonoma:  "f0207ae81e5f00497fdceaf6bb1f39543a898bf6c53014a6a7fe5f9947332c31"
    sha256 sonoma:        "fadabc9dcd1785f75a221154b305da2412c6b458f8ed39009d079abfcbe1e232"
    sha256 arm64_linux:   "cfb656531cb53e1998c2b927b3af1eb132b5e306a6a4a4637eba2c52434cb3cf"
    sha256 x86_64_linux:  "e1a0aa06d130da11d0c329db9f62c1286d2cdbe1e529349a325726972b6e563b"
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