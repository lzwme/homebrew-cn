class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.net/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", revision: "1981"
  version "1.1"
  license any_of: ["GPL-3.0-only", "LGPL-3.0-only"]
  revision 9
  version_scheme 1
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  livecheck do
    url "https://sourceforge.net/projects/fuego/rss?path=/fuego"
    regex(%r{url=.*?/fuego[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "0dbb1891768f85a9c36b14db58234603e26d069f49360d13867158dadeae93e5"
    sha256                               arm64_ventura:  "6a44300bbff33ecef09eb2d1b5bff0410b9797890e4ea779f02559d0e1ba0edb"
    sha256                               arm64_monterey: "32132dfa11c2b34cc950e2af37557f2810380c8c73ccef825d8435ef976583f9"
    sha256                               sonoma:         "a87d398582dada0fb1e95e4ad995cceff5cd1e4e909ad5dc19752c338ac0076b"
    sha256                               ventura:        "58665da1c4178b3b92c1278849c49890f922c6693aea287c769196caa4af0515"
    sha256                               monterey:       "e8b1ae6e1f34af55a1e315f17337b4e1c85c8f9b5bd18869d0a51be34c10030f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c84bb1fce09b8a28c4714436810fb21719a26588c26cc9c67e935deb5381a8da"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"

  def install
    system "autoreconf", "-fvi"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install", "LIBS=-lpthread"
  end

  test do
    input = <<~EOS
      genmove white
      genmove black
    EOS
    output = pipe_output("#{bin}/fuego 2>&1", input, 0)
    assert_match(/^=\s+\w+$/, output)
    assert_match "maxgames", shell_output("#{bin}/fuego --help")
  end
end