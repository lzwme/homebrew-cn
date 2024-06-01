class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https:www.weechat.org"
  url "https:weechat.orgfilessrcweechat-4.3.1.tar.xz"
  sha256 "157e22a17dcc303c665739631a04470d786474e805febed2ed2d5b6250d18653"
  license "GPL-3.0-or-later"
  head "https:github.comweechatweechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "7c5f6b1fc1db9f74727cf30318f6f1630377f9cd2d8153af77fbb3be6bfa9330"
    sha256 arm64_ventura:  "552079d4bbd3305c1d7318a36a53fba9d9fd47afc04e6cad10fd36f9d389280a"
    sha256 arm64_monterey: "7d58cfed426a309167e1acac68cd88f43064562bfa0d284e47b3c0e9dc47d730"
    sha256 sonoma:         "185d304e979da839665286970b7f28d5fb895f4fe503662dbaf3f75d652efe77"
    sha256 ventura:        "fe65c5cbe00664fb51cf524b688e6608815bc3af763885de99f14bff410668d8"
    sha256 monterey:       "1b3d85c0302477249c4a183f3722d3fd79affefbc2bc469af2bee8355eef8fbf"
    sha256 x86_64_linux:   "b7b8896f6f01fee63b3d7467f0fad617337b180847979951e93a45c24ab55e5e"
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
  depends_on "python@3.12"
  depends_on "ruby"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libgpg-error"
  end

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