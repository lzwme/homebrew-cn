class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https:www.weechat.org"
  url "https:weechat.orgfilessrcweechat-4.3.6.tar.xz"
  sha256 "878b06391532ddc40f4b495462a217ebc39925e2eadfe4df84e76a3313647c99"
  license "GPL-3.0-or-later"
  head "https:github.comweechatweechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "6962d4e19889875f6272caf6c3b5cb2fe511fce9b6d7187e48472c7cf9586dcd"
    sha256 arm64_ventura:  "2d85ea85d3763d743b71dfad30a9f089d0c9fba83a188524ea6671db13e35fb1"
    sha256 arm64_monterey: "8a3c7dd739b568ce9bc14c2090219c497a98fece0a35ce0d4f19fbcab2c11df0"
    sha256 sonoma:         "7ea541e7ece44af5a0fda2360871a1b02cbf16c6e0b04d1d3bbc70524e7bce6f"
    sha256 ventura:        "663ae8147b93fd092c7754fd9249fdc84e5d1ab7d13424ae4e8d53923ad11352"
    sha256 monterey:       "64aa09bf62112f3476ead9c2508d5ba6018ed369506d772725a5b49c0aed14e7"
    sha256 x86_64_linux:   "a2cee8e714af48a1c4f303fc6223a489a40e30b0e17dcdf660cb2f6f544a05e8"
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
    system bin"weechat", "-r", "quit"
  end
end