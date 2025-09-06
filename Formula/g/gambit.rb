class Gambit < Formula
  desc "Software tools for game theory"
  homepage "https://www.gambit-project.org/"
  url "https://ghfast.top/https://github.com/gambitproject/gambit/archive/refs/tags/v16.4.0.tar.gz"
  sha256 "13e5431575a240fd5cb7e789fb963967389835e02b1f2f3dd0491d938851795d"
  license all_of: ["GPL-2.0-or-later", "Zlib"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0b7f31bfbf9e517470b7a05715dfc8811c5d4a10b788cdb292081dc61c5f253e"
    sha256 cellar: :any,                 arm64_sonoma:  "906d30bf9d44063baddba7b60668a4ae461fe6e16a5942343ce0bb7e6e779352"
    sha256 cellar: :any,                 arm64_ventura: "bb4d901b2ca8c56931b47521f962b11a4b235b15e428929cb64f7341f5461f7f"
    sha256 cellar: :any,                 sonoma:        "f36ec4099e2f993b3306ec82397e38e00a6db046578a0b44a285db4123c646a4"
    sha256 cellar: :any,                 ventura:       "3170670094311df7dfe8c4f77cdb2d3c77fe451ad911024496cabaefca6a152e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19856d0f8492c5119e8fa4177eaa886eb79e8dc9eaf6d10cbf45c08a63f380ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96883b393aab9507394e10b92dafa6a20162d3719e3d7cbf09ce035b61060f9e"
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