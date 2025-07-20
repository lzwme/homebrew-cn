class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.7.0.tar.xz"
  sha256 "45dc0396060c863169868349ec280af1c6f4ac524aa492580e1a065e142c2cd8"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "2dfd2add90d8b8ce6faa01bc53331e9da8937b6c63bed4e6136a127096ea7bf9"
    sha256 arm64_sonoma:  "a4ec4abf904cbe3240429982c5ac5c8bbd8368bba8fe39a4a298ac2922f52f4c"
    sha256 arm64_ventura: "d5304434de438f2a21aba0c69a4133a05de242ac6762ae74ff3cb981fb1be513"
    sha256 sonoma:        "e90393c9f7a3b331349598a5a40e4d17142bb709e4ad171997a5ee9b9e380b8d"
    sha256 ventura:       "acf08811e48f442633021c83cf47b10307971be3f1c1595d5dab8ae38a20f683"
    sha256 arm64_linux:   "f91e637f1f4926e25d2885a6ca1cdc7f6d93a181749bb751853a173064d4eace"
    sha256 x86_64_linux:  "a9f71dfe5e74c57df6788417cb68763424d10dade22eedc86730f19661da4dc7"
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

  def install
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
    system bin/"weechat", "-r", "/quit"
  end
end