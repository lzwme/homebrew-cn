class Gambit < Formula
  desc "Software tools for game theory"
  homepage "http:www.gambit-project.org"
  url "https:github.comgambitprojectgambitarchiverefstagsv16.2.1.tar.gz"
  sha256 "d6b8bf8a7d42f20e157e0452b323feb260eee7fe06940841ed83e1307978dabc"
  license all_of: ["GPL-2.0-or-later", "Zlib"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "745f8c733cda2467183b230d3f7d05cbb0ac2cc8f84d8b38eed59a110b978c8c"
    sha256 cellar: :any,                 arm64_sonoma:  "03cae53ac72bb53922509cbb6433bfa0920c35f6782144db3975415efd5cb861"
    sha256 cellar: :any,                 arm64_ventura: "029a86328dfa6db4292f222392df2bbf42c3ebce98b858f79e96c0d1061b7cfb"
    sha256 cellar: :any,                 sonoma:        "20273a54ac60a74e29f4e3ee6a92f2b86b27f03baee6851c8b53ed40950fe074"
    sha256 cellar: :any,                 ventura:       "2adb4c55e2f2c98b33c1eac1b69cdbafc220dd5d0725b9af58e6f422e25cac45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e11832da5f73d24bf191fad88d973c9de6646a38275d4460138d9518d6122d6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "wxwidgets"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system ".configure", "--disable-silent-rules",
                          "--with-wx-prefix=#{Formula["wxwidgets"].opt_prefix}",
                          *std_configure_args
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