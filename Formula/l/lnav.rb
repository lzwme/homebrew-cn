class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://ghfast.top/https://github.com/tstack/lnav/releases/download/v0.13.0/lnav-0.13.0.tar.gz"
  sha256 "1d24b9bdb59e3de995de95f6f029ace664e56a80fb0db945077687e86de586b7"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cd7737a5d5f77bd47feb21f3ac514f1226bd38a523ee65d6a5d1256122ec404d"
    sha256 cellar: :any,                 arm64_sonoma:  "ac7a041e92ed298bcf7a6db5f70a5c47abfaed5144b4f69f8db19317ab0011e6"
    sha256 cellar: :any,                 arm64_ventura: "9ab09959db392eb12fa43e06f3d3d3a12703af96063cf4bf78ad5db509a6e733"
    sha256 cellar: :any,                 sonoma:        "a6721887e91df9ddbe85af51acd7a08a2bcd763ef1898212ac2ec12c7bccb9da"
    sha256 cellar: :any,                 ventura:       "8de06184bb0dfb301ef17bfee50609c395cdc93838c3ef256bb565b8c8e76a82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5415f4369a12cff44b245887aa88b7e0908fbd3e4eb496f62b0c693985d1b1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6043caf68659d065c227e3bd4ae076528df283c9bc8d821cb6896c3f4688bf3"
  end

  head do
    url "https://github.com/tstack/lnav.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "rust" => :build
  depends_on "libarchive"
  depends_on "libunistring"
  depends_on "ncurses"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--with-sqlite3=#{Formula["sqlite"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libarchive=#{Formula["libarchive"].opt_prefix}",
                          "--with-ncurses=#{Formula["ncurses"].opt_prefix}",
                          *std_configure_args
    system "make", "install", "V=1"
  end

  test do
    system bin/"lnav", "-V"

    assert_match "col1", pipe_output("#{bin}/lnav -n -c ';from [{ col1=1 }] | take 1'", "foo")
  end
end