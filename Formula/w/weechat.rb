class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https:www.weechat.org"
  url "https:weechat.orgfilessrcweechat-4.4.3.tar.xz"
  sha256 "295612f8dc24af28c918257d3014eb53342a5d077d5e3d9a3eadf303bd8febfa"
  license "GPL-3.0-or-later"
  revision 1
  head "https:github.comweechatweechat.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "9cacde305627d8658022b0313c9dd7d12033a6e6fc14a2d37190d15bf3e04d3b"
    sha256 arm64_sonoma:  "9f3b5c57ba2d43bff0332b436d86a574b7293246c5a71c62f57e8183db7d8787"
    sha256 arm64_ventura: "caa314956a5b9decc181db8c61265dfaf6ceec5fc3500170dfef2a7975e26d29"
    sha256 sonoma:        "ca6d5340d259308d95e997d521ea5deb4d4311d0789ca7340b3f69e4c030b377"
    sha256 ventura:       "296535cd4f2c21516459e1ccf736c668eb5d8eb04672e89629955bb596cbba0c"
    sha256 x86_64_linux:  "ba6c3551dcc8fe598e511f7bf833caa8d6003de83d2c3c04639a53f60289fe58"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
    # Help pkgconf find python as we only provide `python3-embed` for aliased python formula
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