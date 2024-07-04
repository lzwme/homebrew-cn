class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https:www.weechat.org"
  url "https:weechat.orgfilessrcweechat-4.3.4.tar.xz"
  sha256 "cad458022f4699120b7d72e062b346c4d0e78359cc9785fa2e1686fd74ba7f67"
  license "GPL-3.0-or-later"
  head "https:github.comweechatweechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "0e323f9e5085d6bb923fc788071252b39f83e051e840f353ec76ecc202ba842c"
    sha256 arm64_ventura:  "ef6b600e3c44da9490265c6bfa1c65bdbed83be4b4a0fc3dce101857a152b117"
    sha256 arm64_monterey: "abd6535db40afeb5db1c956c1255a1b9b2b8cf60695ec7ee83e5c930f0f1ab3e"
    sha256 sonoma:         "22a2bd7624907fc016eb577d06b8f9c7c6b8a7252ca9ce77c5f3b55da84d12e2"
    sha256 ventura:        "e692e0f4d97656f1c59c0b89bfc5e03b668c760cbfb3448bf92c73ed01ec5ce6"
    sha256 monterey:       "7922c099b0d8a6a521162d3e5c7bd84637d5fd3827211b761a665ddd8ea58b00"
    sha256 x86_64_linux:   "cb11a0c962be1ed24d2f139576a7c00f9fcba0a8d4f9668a3ff5d388d255bd9e"
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