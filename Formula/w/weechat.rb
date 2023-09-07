class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-4.0.4.tar.xz"
  sha256 "ae5f4979b5ada0339b84e741d5f7e481ee91e3fecd40a09907b64751829eb6f6"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "9c218ef0fbab62664257aebd1d02d97d87bf3bf7d1235065272beed54c578a3c"
    sha256 arm64_monterey: "3dc6b1b4b7b6050f35ef83fdc21ab56cb8414fc75a1f1c4e87182543e5dff57b"
    sha256 arm64_big_sur:  "6ad0d5f7f5797892e256a6af3f7d231ba605a39f659e296321587fef4906b99b"
    sha256 ventura:        "e2ae47ee02a1dee06a593d6b1717fb3de5e2b6f60d1a71df209044f7b7e37faf"
    sha256 monterey:       "cdf2e397a30a62828e6cc2ac12b09b4b07aa83f10b953e4ef948ff53b9e82fa5"
    sha256 big_sur:        "0343160e93ff7a05b39f640fb31d7b49808ec3f2d690ecec7b2945ea61f82473"
    sha256 x86_64_linux:   "2d36f86333dd1f4d86a2bfce4b5c622cac1510d0a15aac4c57bf9b059119d146"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.11"
  depends_on "ruby"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"

  def install
    python3 = "python3.11"
    pyver = Language::Python.major_minor_version python3
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace "cmake/FindPython.cmake", " python3-embed ", " python-#{pyver}-embed "

    args = %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{Formula["gnutls"].pkgetc}/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
    ]

    if OS.linux?
      args << "-DTCL_INCLUDE_PATH=#{Formula["tcl-tk"].opt_include}/tcl-tk"
      args << "-DTK_INCLUDE_PATH=#{Formula["tcl-tk"].opt_include}/tcl-tk"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end