class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-702.tar.gz"
  sha256 "242a64c00f02d96f8ee208cf638ae1728b727c7f5fdf82a7d4f4cae32fb084e2"
  license "GPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+(?:\.\d+)*).+?released.+?general use/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ba3d1a4959f48493e0f62dd5ae2d210a52b44d08a1025c3117a408712ff61b8e"
    sha256 arm64_sequoia: "3c77d010172cb2fa00f9c483483df5f879e111d0b60af97f7ae8dbff18203cd6"
    sha256 arm64_sonoma:  "7c4b6c8c1eb4030d224c70609339ace52d9aad2792052a65b45438c3fbbfd128"
    sha256 sonoma:        "6fc61e79fecad590a141626aad341200c0a84141ba748cffb987e806bba5f04a"
    sha256 arm64_linux:   "d6b37c701690c6e9ba4803be022830c1dcc21c49be2a110d1ad0de8e0f589c4e"
    sha256 x86_64_linux:  "b18c5b761c425510ba9bec59c612a4eeda2795c33ff8f22e943632e130dbc7fc"
  end

  head do
    url "https://github.com/gwsw/less.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "groff" => :build
    uses_from_macos "perl" => :build
  end

  depends_on "ncurses"
  depends_on "pcre2"

  def install
    system "make", "-f", "Makefile.aut", "distfiles" if build.head?
    system "./configure", "--prefix=#{prefix}", "--with-regex=pcre2"
    system "make", "install"
  end

  test do
    system bin/"lesskey", "-V"
  end
end