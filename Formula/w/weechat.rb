class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https:www.weechat.org"
  url "https:weechat.orgfilessrcweechat-4.4.3.tar.xz"
  sha256 "295612f8dc24af28c918257d3014eb53342a5d077d5e3d9a3eadf303bd8febfa"
  license "GPL-3.0-or-later"
  head "https:github.comweechatweechat.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "cec222dbbd739d191ccb0e24b65d793d978939574548901614e6fc94697cbd35"
    sha256 arm64_sonoma:  "732460c8889c5a94f3b0e1e77ff96017d95664f4cf3f1fd7d1412ebacb97a43a"
    sha256 arm64_ventura: "8d47225c1dfc8e06e66c3f1c0c3ad90d0b7d09b5de66c64aa3b2676f36d284c7"
    sha256 sonoma:        "e0bff8aac7e66e97d4804b98e986e185e1e311d3582217cb4f2f112317ea6680"
    sha256 ventura:       "c3f26ccce2a9cbfaf2fcf0b7d0e2fce1e100e95c33b1b186e45d272df2b6d594"
    sha256 x86_64_linux:  "1b01f8b4e4ea1029d4be058262ee021477faf875bc65e6f2608f1180a3a472b9"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "cjson"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.13"
  depends_on "ruby"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libgpg-error"
  end

  def python3
    which("python3.13")
  end

  def install
    pyver = Language::Python.major_minor_version python3
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace "cmakeFindPython.cmake", " python3-embed ", " python-#{pyver}-embed "

    args = %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{Formula["gnutls"].pkgetc}cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
    ]

    if OS.linux?
      args << "-DTCL_INCLUDE_PATH=#{Formula["tcl-tk"].opt_include}tcl-tk"
      args << "-DTK_INCLUDE_PATH=#{Formula["tcl-tk"].opt_include}tcl-tk"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"weechat", "-r", "quit"
  end
end