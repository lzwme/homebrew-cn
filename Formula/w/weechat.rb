class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https:weechat.org"
  url "https:weechat.orgfilessrcweechat-4.5.2.tar.xz"
  sha256 "1a65466dcd3edb7378f27a611e06e2f7f45a6028ae54d3e1696ca91e85ec1459"
  license "GPL-3.0-or-later"
  head "https:github.comweechatweechat.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "3f93bbbe217723dda5abf20b5564c53da5f697dcf8944be63b77cbf14f5070d7"
    sha256 arm64_sonoma:  "6f9314e37647daf68b5d2a4d656a428e81a1d294cbb6e6fa03a2773142ef0d7e"
    sha256 arm64_ventura: "3fcd8af2fd73e2eb06261897fb46a58b2bdf92bdf6a5c4d8fe47bf6faa362e29"
    sha256 sonoma:        "a7806666c3317823c07fe0524f1f5c74ab40abb3119b6f07f353ab3013e2ea07"
    sha256 ventura:       "22915d3e4913a3c522b1c46515a923acf232b5744769dc6761a8f7c6b4900cf0"
    sha256 arm64_linux:   "e2dee2cf6486b63d60a7ceb93c0c42df0277b9b8964b5ab462167cf64d1bf23c"
    sha256 x86_64_linux:  "5d5ceec518682cc720d346f2a5d0f06cd5c7fe240c286cf075aa9e196c59d01f"
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