class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.2.tar.bz2"
  sha256 "faabf6157c8cb1b24a059af276e162fa9f9a3b9cd3810c43b9128860c9383a1b"
  license "GPL-2.0-or-later"
  revision 13

  livecheck do
    url "https://rybczak.net/ncmpcpp/installation/"
    regex(/href=.*?ncmpcpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "40d4913d8c556937fa9ca9494127af13941cad9183c8f8b7016186083594091e"
    sha256 cellar: :any,                 arm64_ventura:  "502d720759a4e969aaa175cecdb283cfc229e4539eac1e1717aaeeaf43dc4abd"
    sha256 cellar: :any,                 arm64_monterey: "5031c0d057f776c111c5167ffcffc0d08e06706617aa20f6cf07272f0f70268f"
    sha256 cellar: :any,                 sonoma:         "1b97a0523f3d07043b4e31dde84b28205472c44d2f5cfb4e2713aa76eaab285c"
    sha256 cellar: :any,                 ventura:        "a9dbc49286030bcc299435381654eb4f8553e1a3bb1b7ce34e350a5665a6c2be"
    sha256 cellar: :any,                 monterey:       "fe26e3f3af539d13b86e7de615b30ba2b8dcf120cc776d19fb0ed03001c08789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc2c8f3114843c49ce5657f734946f4dcc2390c0506512331af3377aaf9a391f"
  end

  head do
    url "https://github.com/ncmpcpp/ncmpcpp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "fftw"
  depends_on "icu4c"
  depends_on "libmpdclient"
  depends_on "ncurses"
  depends_on "readline"
  depends_on "taglib"

  uses_from_macos "curl"

  def install
    ENV.cxx11

    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    ENV.append "BOOST_LIB_SUFFIX", "-mt"
    ENV.append "CXXFLAGS", "-D_XOPEN_SOURCE_EXTENDED"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-clock
      --enable-outputs
      --enable-unicode
      --enable-visualizer
      --with-curl
      --with-taglib
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    ENV.delete("LC_CTYPE")
    assert_match version.to_s, shell_output("#{bin}/ncmpcpp --version")
  end
end