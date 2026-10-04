class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.10.1.tar.xz"
  sha256 "b8744c6f5dc5543062791f563e0516dbc96a36161e1a03c468b3b7dcc8be5aff"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/weechat/weechat.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "44c8714f960cd7bb425902245289e1a238c720dc697e662fc0af1a2273a8cf6e"
    sha256 arm64_tahoe:       "8f1cbbeaac2ec0684a9d2ce2e4b2d1454f34b752cb6e5e09642017b8626062af"
    sha256 arm64_sequoia:     "eb8d4dc8954a31d90bda1a405603f3ace79f7d63553774739c7a7822fad29baa"
    sha256 arm64_linux:       "22d323c3ebdac40110cea3e4854d45362f97079e19cbf1520d38fd6a0e52e3b1"
    sha256 x86_64_linux:      "2f4fa98892f228860de30bcaefa6acd11af7694194f82dc892e5de28601e7802"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "gettext" => :build # for xgettext
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "enchant"
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
      -DENABLE_ENCHANT=ON
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
      args += %W[
        -DPERL_EXECUTABLE=#{perl}
        -DPERL_INCLUDE_PATH=#{MacOS.sdk_path}/#{perl_archlib}/CORE
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"weechat", "-r", "/quit"
  end
end