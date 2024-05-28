class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https:www.weechat.org"
  url "https:weechat.orgfilessrcweechat-4.3.0.tar.xz"
  sha256 "36f9f90bf2f69f77a34d1e0d58f06ca08f0f20f8263ab940b637e7abf796862d"
  license "GPL-3.0-or-later"
  head "https:github.comweechatweechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "3d706fdb473e748356a3a0bed3f3a104e5fe51ab9553409e01b1083056598053"
    sha256 arm64_ventura:  "cdb176248bf205be8754ae27cc428ba5ae23e8fbda22b4970be2d0f061c5a29c"
    sha256 arm64_monterey: "09434f08bdf7e2e95cb4e0d0a083e159ebfcb9fc0540fb6f89526aa6751a89a0"
    sha256 sonoma:         "240bf0aaf62edcd861e29297972076d7948abb23e49376514dbb1836bdf77829"
    sha256 ventura:        "104f938f5b96b5f74c8c037ca4f839f09015ecfa28f6ae135bf678e8a722f16f"
    sha256 monterey:       "d4e792d5e855fc954e66e804d81b41cbb78e9df08e909572269ab74e24515394"
    sha256 x86_64_linux:   "cef2fc0b0291ff1587029056d7ca749523d686a2326a7e7fc2b7066ee5ddef5b"
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