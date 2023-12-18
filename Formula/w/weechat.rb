class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https:www.weechat.org"
  url "https:weechat.orgfilessrcweechat-4.1.2.tar.xz"
  sha256 "9a9b910fbe768bb9de7c7ac944f5db8f233833f345b2e505e16ec6ef35effbb5"
  license "GPL-3.0-or-later"
  head "https:github.comweechatweechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "49dd6382c9c962832cd8f7f103bc9407c2aab65c4c298ba41bab218ec3483774"
    sha256 arm64_ventura:  "9104547bea0ddbfda85cd60a91feb635d6e236df0af823c94f6f4c5eaddf0682"
    sha256 arm64_monterey: "f4ac3482770407a45bd501fb4d68ecc846039efd6f215a0a02d8ea84872f42de"
    sha256 sonoma:         "92956a5cfe954ed0bcac28e55f9c0bfe13ea7345b3909d15acce2395ac618348"
    sha256 ventura:        "3077f127a7721574e2c676888142020da25f81a131c29fc3b27ceb4b9d520e1c"
    sha256 monterey:       "256203a53e8d74abdab4da0645b24489211b0c19e6be47e50d12ba24e22b7553"
    sha256 x86_64_linux:   "21ce7f7d32a3cf4a69ddcef3fb32b8fe1bf904d7f845f20bf2cadf160cdeff94"
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
  depends_on "python@3.12"
  depends_on "ruby"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"

  def python3
    which("python3.12")
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
    system "#{bin}weechat", "-r", "quit"
  end
end