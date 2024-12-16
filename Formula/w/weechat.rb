class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https:weechat.org"
  url "https:weechat.orgfilessrcweechat-4.5.0.tar.xz"
  sha256 "b85e800af0f7c9f2d60d72c0f7e56abbaa60274a4d47be17407907292da30398"
  license "GPL-3.0-or-later"
  head "https:github.comweechatweechat.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "b1c4a9ff568f0dd51986c756eb1072fb0ae218ffbdf9524568f6f5e232ae1faf"
    sha256 arm64_sonoma:  "44d832074e55ff04bac91aa53ed7a2445a7149e57a0fb29899b33bfa12dc6f1b"
    sha256 arm64_ventura: "91b16c3ebbf709078c3296944ebeba7046c4de4575e4d707df3cadffa6864a3c"
    sha256 sonoma:        "782104a1814e7ff0870eb6e298bb0a8e7d60012d5cec9e00f234ef937acef1cd"
    sha256 ventura:       "14928da6ab09fda8d22edaa6239a9bc3c84a514734a1149ac0302bbcfb9b7a3c"
    sha256 x86_64_linux:  "8cf368ee782b32edb2886b8ad6c13a3eb553771fe3c20d5c61bad487b426c536"
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