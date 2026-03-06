class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.8.1.tar.xz"
  sha256 "e7ac1fbcc71458ed647aada8747990905cb5bfb93fd8ccccbc2a969673a4285a"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/weechat/weechat.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "ea5902bdc85a2b4459d66b1713b6dba788699d395b0f2e37e0152618463b227b"
    sha256 arm64_sequoia: "c02ec0f9fe7c1cfbcb765617a5f4def60348ff7f2e81f8cb03ff2d4e24e65021"
    sha256 arm64_sonoma:  "be4f59101aab8499c5c1b5d4f059a82df4f5dc8d606d06267cba04e00844883f"
    sha256 sonoma:        "3bf3ac092a21393ecc8671c17eaf552c77cd2ee3bde6ec555ce5699430b154c0"
    sha256 arm64_linux:   "9d9998316c13265c985ede2f0f3e053bd87960a75231d62dda01e318c1156754"
    sha256 x86_64_linux:  "18fd015dfc8058368a708d6d825218e45a6b0275d9f35a31059a5840e410ef52"
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
  depends_on "python@3.14"
  depends_on "ruby"
  depends_on "tcl-tk"
  depends_on "zstd"

  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
    depends_on "libgpg-error"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    tcltk = Formula["tcl-tk"]
    args = %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{Formula["gnutls"].pkgetc}/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
      -DTCL_INCLUDE_PATH=#{tcltk.opt_include}/tcl-tk
      -DTCL_LIBRARY=#{tcltk.opt_lib/shared_library("libtcl#{tcltk.version.major_minor}")}
      -DTK_INCLUDE_PATH=#{tcltk.opt_include}/tcl-tk
      -DTK_LIBRARY=#{tcltk.opt_lib/shared_library("libtcl#{tcltk.version.major}tk#{tcltk.version.major_minor}")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"weechat", "-r", "/quit"
  end
end