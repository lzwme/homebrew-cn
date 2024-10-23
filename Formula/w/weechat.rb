class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https:www.weechat.org"
  url "https:weechat.orgfilessrcweechat-4.4.2.tar.xz"
  sha256 "d4df289a9c5bca03a6d4fae006e52037064ef03bad6fbe959c538f3197434dec"
  license "GPL-3.0-or-later"
  revision 1
  head "https:github.comweechatweechat.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "b767a24e99e8f11a445abd015355d06acb78a7c75d202bde85b4af5566019b47"
    sha256 arm64_sonoma:  "a533bda3a59faeb5aa8e8f283173a42d4c07f38032570616b2370aad40cc76d8"
    sha256 arm64_ventura: "60c6ab13d61bea9d885f5c1eb38765653b3765804760e5ca5b6160b38437b858"
    sha256 sonoma:        "5bca5158ce803c901d1db1a5c7c4bb57915852c4a83d9645ee8ac8ffcfe607e5"
    sha256 ventura:       "503e2083f302de253c49b3eee14a16f914960c733354550f8d916868bd3c6062"
    sha256 x86_64_linux:  "70d404f12926f8fe36492c2084724ce46720bbb3eb305ce3134cca1efaac98f7"
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