class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.7.1.tar.xz"
  sha256 "e83fb71ca251c5dd74bd9c5a6bd3f85dc2eb8ecec0955f43c07f3e0911edb7d3"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "cc4e5e1bf923e7661a853e31f11ee85bdd34f18c52dc58fb930078ecd92f0101"
    sha256 arm64_sonoma:  "97d570fc05deee3831ee139a1b6c1d41160e9379b235d4f10eaaaaf18c043632"
    sha256 arm64_ventura: "8bbb387e517c2515170dc58c490a405607bb176c96444a61e692f5ab5d457adb"
    sha256 sonoma:        "9cfa39417c7dc72603d6441222302f62bde372ba7159ba804ca5258daad59224"
    sha256 ventura:       "8fe8019d2bc46c6513b11f6135acbc6b861f3460973fc165a86f2fb9c1fd617d"
    sha256 arm64_linux:   "50332a7573a9ea88d10b5447d599b0e03d584727bbda5e6d7c9e9363660cc81f"
    sha256 x86_64_linux:  "1072c047689580fe404dae14f28c0bbe0d32dd08fe5d40ad76c2b8b0cc4468c0"
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