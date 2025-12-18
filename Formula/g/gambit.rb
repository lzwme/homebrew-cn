class Gambit < Formula
  desc "Software tools for game theory"
  homepage "https://www.gambit-project.org/"
  url "https://ghfast.top/https://github.com/gambitproject/gambit/archive/refs/tags/v16.4.1.tar.gz"
  sha256 "73718a47201b7a602c33d351faa4dd161247217a68c450eec9f2d7b0d1ef69f7"
  license all_of: ["GPL-2.0-or-later", "Zlib"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b551b800de18e4a91c5b6489a25a9a14e3606ac0395ea478843d0e2bd7314d51"
    sha256 cellar: :any,                 arm64_sequoia: "7eda66fb3af412ec412e2196d530ed511f17401d0d349d23ab14653b61f78681"
    sha256 cellar: :any,                 arm64_sonoma:  "dea3a273a571884e6122365ad5bfbfaacc1e033b0df9e56d2c81ba72172eb17f"
    sha256 cellar: :any,                 sonoma:        "46d4484efc0bf3dbdbac3c8073e3dd262f4fa47699173177a008c33eb17d97e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5800ddb4160b18eff0e0b7027d8c8a78aa120447968caf85e17b46320177863f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a945d477244c5a983dbb6caa5395bdce7a81fafd48b0965fb7035efaf4e2237"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "wxwidgets"

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