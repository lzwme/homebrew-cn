class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.8.2.tar.xz"
  sha256 "7e2f619d4dcd28d9d86864763581a1b453499f8dd0652af863b54045a8964d6c"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "0c43de78771adcbc792ba4da4af78a915def6cc272b557c1f80016f63e700077"
    sha256 arm64_sequoia: "c1e9debdd1af7dc7e3c1300a59bbc9a68ec6aa53996c87153994a8b45bb69279"
    sha256 arm64_sonoma:  "1e602b4f506a84cb7067739b4d77726357531abca288943f606d9aba7240634a"
    sha256 sonoma:        "5796454f3891b552099d995d147ea429419a673cc6cce016dfac65c2a852c454"
    sha256 arm64_linux:   "0c3dceb38f9465bba564acbd6587af01b9f6c33289f942f6bb25f9f26aa4d71f"
    sha256 x86_64_linux:  "2d336a88c9e9c221c572d5d44e2684ed0dce4d7868835f71c2b0c3aeafcb6fc8"
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
  depends_on "python@3.14"
  depends_on "ruby"
  depends_on "tcl-tk"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "perl"

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
      -DENABLE_GUILE=OFF
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_MAN=ON
      -DENABLE_PHP=OFF
      -DTCL_INCLUDE_PATH=#{tcltk.opt_include}/tcl-tk
      -DTCL_LIBRARY=#{tcltk.opt_lib/shared_library("libtcl#{tcltk.version.major_minor}")}
      -DTK_INCLUDE_PATH=#{tcltk.opt_include}/tcl-tk
      -DTK_LIBRARY=#{tcltk.opt_lib/shared_library("libtcl#{tcltk.version.major}tk#{tcltk.version.major_minor}")}
    ]

    # Help CMake find Perl header on macOS due to non-standard layout
    if OS.mac?
      perl = DevelopmentTools.locate("perl")
      perl_archlib = Utils.safe_popen_read(perl.to_s, "-MConfig", "-e", "print $Config{archlib}")
      args << "-DPERL_INCLUDE_PATH=#{MacOS.sdk_path}/#{perl_archlib}/CORE"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"weechat", "-r", "/quit"
  end
end