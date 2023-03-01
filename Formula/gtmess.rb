class Gtmess < Formula
  desc "Console MSN messenger client"
  homepage "https://gtmess.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gtmess/gtmess/0.97/gtmess-0.97.tar.gz"
  sha256 "606379bb06fa70196e5336cbd421a69d7ebb4b27f93aa1dfd23a6420b3c6f5c6"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256                               arm64_ventura:  "b900139985694c245c0211f9fea3ccdaa14fbde5094d7201bccb51029fd9ce41"
    sha256                               arm64_monterey: "19e8f974e8f84874a9d06a195d5a45b8c2d881689f767706eec5692589a6af4c"
    sha256                               arm64_big_sur:  "a0b6c3219910c5014fb968fad3d3cf06694f5f2fc173b615df3d04e8e8b5e93d"
    sha256                               ventura:        "4ede269a5b42a857aa94e09d68eb889de5a15a190145efd09fb07b907971b4c7"
    sha256                               monterey:       "ff05dfd808dd3c468e004dfa944117208e9f44bfe542bd45cbaa851f8981e04a"
    sha256                               big_sur:        "28119023b99b93091412443d9ca881c06cd120b97f60719bf3705680d8c2eb39"
    sha256                               catalina:       "b371a2eba5b1703eb6598daae20d72b08a866fe1db95505a9cfddacc470d4804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae09e63f26ccef723a73cf04f5dc36ba60ab1588b558d15b5e248132d7d88eea"
  end

  head do
    url "https://github.com/geotz/gtmess.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args, "--with-ssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/gtmess", "--version"
  end
end