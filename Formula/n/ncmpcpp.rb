class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https:rybczak.netncmpcpp"
  url "https:rybczak.netncmpcppstablencmpcpp-0.9.2.tar.bz2"
  sha256 "faabf6157c8cb1b24a059af276e162fa9f9a3b9cd3810c43b9128860c9383a1b"
  license "GPL-2.0-or-later"
  revision 19

  livecheck do
    url "https:rybczak.netncmpcppinstallation"
    regex(href=.*?ncmpcpp[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3e9fd5119dc58fef9d8d0fa4f5e26ad68d777df16c19fb47674b7e7f0e910b00"
    sha256 cellar: :any,                 arm64_sonoma:  "6fd604cd6d2094ab0b6a8b904a6d5b9c2b409c52c24ca7ab090bcc3abfbad2e8"
    sha256 cellar: :any,                 arm64_ventura: "05e9b88fb40c43f54fa994c3d953c4a85010f2ffe1fc3be63713af7c39934700"
    sha256 cellar: :any,                 sonoma:        "495e51045de2902f8ac3d13845e4c210576328aae67c8dedecb81b09bd83377a"
    sha256 cellar: :any,                 ventura:       "ab52d5fd05a6587ea18eb84ff0860df33cb66c30405fc70f683c28182bc6f78b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35f0ea3a8ebe207c8581f45a7cf18a407b7ab07e28e5dadc608d619c5ed8c505"
  end

  head do
    url "https:github.comncmpcppncmpcpp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "fftw"
  depends_on "icu4c@76"
  depends_on "libmpdclient"
  depends_on "ncurses"
  depends_on "readline"
  depends_on "taglib"

  uses_from_macos "curl"

  def install
    # Work around to build with icu4c 75 in stable release. Fixed in HEAD.
    # Ref: https:github.comncmpcppncmpcppcommitba484cff1e4ac3225b6eb87dc94272daca88e613
    inreplace "configure", \$std_cpp14\b, "-std=c++17" if build.stable?

    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    ENV.append "BOOST_LIB_SUFFIX", "-mt"
    ENV.append "CXXFLAGS", "-D_XOPEN_SOURCE_EXTENDED"

    args = %w[
      --disable-silent-rules
      --enable-clock
      --enable-outputs
      --enable-unicode
      --enable-visualizer
      --with-curl
      --with-taglib
    ]

    system ".autogen.sh" if build.head?
    system ".configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    ENV.delete("LC_CTYPE")
    assert_match version.to_s, shell_output("#{bin}ncmpcpp --version")
  end
end