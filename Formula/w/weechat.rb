class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https:weechat.org"
  url "https:weechat.orgfilessrcweechat-4.6.0.tar.xz"
  sha256 "2681fc662996fead9d66a26d81740088e4284cf4e6dfe6b834f3b98fc703597f"
  license "GPL-3.0-or-later"
  head "https:github.comweechatweechat.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "8d7e5d3f717d93a2723bd19d964ef71824be45b61edc86946c1ce3f5aa53936b"
    sha256 arm64_sonoma:  "accf8d404da363680ceb4da0d7cdc649cf39b142216bafdf696b0677aac58135"
    sha256 arm64_ventura: "e9e3607db8825a0499022cf85e73c65c845eef1a68c304bae9ecf4fdea1204fe"
    sha256 sonoma:        "938959d95e9646573539a3cc72ac0a924a7ab0c1143e0aff29de78d18bfa5b58"
    sha256 ventura:       "1424015f1b18d6f103333b0cffcb636477b137662dc269b1c835878673c9dbcf"
    sha256 arm64_linux:   "9af16d0b5f05b1a62265e80f2caae47ce74ae9fd756007a5df6814a3985ab3bf"
    sha256 x86_64_linux:  "358907b76f05d81b8c88939704f60c01398bbf3695432f148731da578d3c3dfc"
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
  depends_on "python@3.13"
  depends_on "ruby"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
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