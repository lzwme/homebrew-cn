class Gambit < Formula
  desc "Software tools for game theory"
  homepage "https://www.gambit-project.org/"
  url "https://ghfast.top/https://github.com/gambitproject/gambit/archive/refs/tags/v16.3.1.tar.gz"
  sha256 "9c74edc790df92a5a6a8a2a7e98f7d28d1ee72e85689f3ef8a3f7dcc2a816a4d"
  license all_of: ["GPL-2.0-or-later", "Zlib"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9a1e75aee1791314e4b7a7e7cbfea84a1f96917a37a6b3ea6eae71fcb1598996"
    sha256 cellar: :any,                 arm64_sonoma:  "43afec9cce61a3da0cc536bc5c8184b5c6e9c2c7aba4954710aeb47b8ea09d98"
    sha256 cellar: :any,                 arm64_ventura: "4679f34e1b4a04f48d04981122bf9238f1a9ddd295f2b77d2e1056185f09982c"
    sha256 cellar: :any,                 sonoma:        "fba25a449fd92efab332cf4dfbbb063b15d3fa2a02d069e1d7120d99ff20fb05"
    sha256 cellar: :any,                 ventura:       "418174607c01f17e7a4b9978dade851e8150937970b07f38da05d36891ca8c1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "536cfc1859207861267b527ea9884f33b2b1ae730b879cb46e1fa95143ab591a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21e0cf50f398dee049b4020f8577e2406ea3805fd09bf438c2f19cccc10f982a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "wxwidgets@3.2"

  def install
    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--with-wx-config=#{wx_config}",
                          *std_configure_args
    system "make", "install"

    # Sanitise references to Homebrew shims
    rm Dir["contrib/**/Makefile*"]
    pkgshare.install "contrib"
  end

  test do
    system bin/"gambit-enumpure", pkgshare/"contrib/games/e02.efg"
    system bin/"gambit-enummixed", pkgshare/"contrib/games/e02.nfg"
    system bin/"gambit-gnm", pkgshare/"contrib/games/e02.nfg"
    system bin/"gambit-ipa", pkgshare/"contrib/games/e02.nfg"
    system bin/"gambit-lcp", pkgshare/"contrib/games/e02.efg"
    system bin/"gambit-lp", pkgshare/"contrib/games/2x2const.nfg"
    system bin/"gambit-liap", pkgshare/"contrib/games/e02.nfg"
    system bin/"gambit-simpdiv", pkgshare/"contrib/games/e02.nfg"
    system bin/"gambit-logit", pkgshare/"contrib/games/e02.efg"
    system bin/"gambit-convert", "-O", "html", pkgshare/"contrib/games/2x2.nfg"
  end
end