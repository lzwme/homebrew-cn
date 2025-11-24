class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.7.2.tar.xz"
  sha256 "66624bd905a6db58a0893bfbdddbb8fa417b97aab4a9af8c140e0b29ceba2569"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "863c51508f75e921939ee372052e6a6eceeae1bf96853a21595f86c62965f307"
    sha256 arm64_sequoia: "ec92f782447fa2183552df385cb8c9d80cc40d189e52a432aa29f70471910b81"
    sha256 arm64_sonoma:  "e055d04ed104e7e7ad87efb3eb5d335a17be46ba784b3bf3fd19c7f0ff0097bf"
    sha256 sonoma:        "3f4dfd56c0e3348f043aafa4ca20648d03f8708c5537a16f9c0621871c7bccdb"
    sha256 arm64_linux:   "0fce0d4da82d52bdf241d14381eb187013111cb7b63edb97b304c60e41cf3316"
    sha256 x86_64_linux:  "465039a97c6a0b1a05ea9d93260e9982bb5079a1a4e39fd872698ff05de2ba79"
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