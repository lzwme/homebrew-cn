class Gambit < Formula
  desc "Software tools for game theory"
  homepage "http:www.gambit-project.org"
  url "https:github.comgambitprojectgambitarchiverefstagsv16.1.0.tar.gz"
  sha256 "de3e3d561cf46aeaec135efaf23f41ddef28968d9071251ca8cb6266babece62"
  license all_of: ["GPL-2.0-or-later", "Zlib"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0f7167c81ed8284493c0823edd9f83a715084433e1a2f4de79c638c2a86058d9"
    sha256 cellar: :any,                 arm64_ventura:  "5b5d2d8c2bc1e987e25ff250fe087f30e414ca72d6f30ba062f0c749e55a4403"
    sha256 cellar: :any,                 arm64_monterey: "344c69984e404b101446cea287bcab018c52ee726bbb1d8ff6d75b2502396e87"
    sha256 cellar: :any,                 sonoma:         "3f9eb0214ae51afbd18abe8f295207656118cdc4a85a1a0a0c35a420893f1371"
    sha256 cellar: :any,                 ventura:        "5de50218265d69c4c8624f6be43d317e9679201c138ce40c081c1d61a7deb325"
    sha256 cellar: :any,                 monterey:       "49117412f0e3ba6bd363db338b981c1b7b9a548dc617c92e1b7882ec43144ee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bce95ec53af3ae5cb8dfeb5b2019d98e8398e65b9fb39a1e2918b6813ac1799"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "wxwidgets"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system ".configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-wx-prefix=#{Formula["wxwidgets"].opt_prefix}"
    system "make", "install"

    # Sanitise references to Homebrew shims
    rm Dir["contrib**Makefile*"]
    pkgshare.install "contrib"
  end

  test do
    system bin"gambit-enumpure", pkgshare"contribgamese02.efg"
    system bin"gambit-enummixed", pkgshare"contribgamese02.nfg"
    system bin"gambit-gnm", pkgshare"contribgamese02.nfg"
    system bin"gambit-ipa", pkgshare"contribgamese02.nfg"
    system bin"gambit-lcp", pkgshare"contribgamese02.efg"
    system bin"gambit-lp", pkgshare"contribgames2x2const.nfg"
    system bin"gambit-liap", pkgshare"contribgamese02.nfg"
    system bin"gambit-simpdiv", pkgshare"contribgamese02.nfg"
    system bin"gambit-logit", pkgshare"contribgamese02.efg"
    system bin"gambit-convert", "-O", "html", pkgshare"contribgames2x2.nfg"
  end
end