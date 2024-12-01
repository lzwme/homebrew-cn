class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https:www.weechat.org"
  url "https:weechat.orgfilessrcweechat-4.4.4.tar.xz"
  sha256 "a8f4bb768c3d6ac3ea1eb4e6dc7a7bb2ee19b734a72cc58e063476dae8f3d077"
  license "GPL-3.0-or-later"
  head "https:github.comweechatweechat.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "3313597c11679c2856bf060ef912aa99812affdc9c7f1b1071ecb40df6e8e5db"
    sha256 arm64_sonoma:  "31ba3d298668a1f3b60750481b23d4843d350ba7da1536e4f2e55ceca50bd055"
    sha256 arm64_ventura: "45cf9fe1b46c4a2eab413e8ef20c086c6f488e86157f9d4b6c4af201502a1ba3"
    sha256 sonoma:        "acb15546575451c62126801bc6947cca3bd7c2efa54c814a01b886a214a94252"
    sha256 ventura:       "d57c1d927d6f398425822ed6808d0d0e1575ab2273b3386eed80454bf18ed9a9"
    sha256 x86_64_linux:  "53598051acfe10af90d4a5d709e06e9fbd3fbe4ab93a346928d0529f9b5d77ac"
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