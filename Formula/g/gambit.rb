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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "3fc6ab0fe551df62fbe58c44d33b6e294996c24f35f9edbc5e2fea06c9dd5612"
    sha256 cellar: :any,                 arm64_sonoma:  "3e3701abf841a6aa7177d8088b6664ef03f121bf28e149d8432be31b6478d8c1"
    sha256 cellar: :any,                 arm64_ventura: "e4997419e975a80bbe911d957bb9f7bf7769495e74864accaa448aa5bd5d86a5"
    sha256 cellar: :any,                 sonoma:        "08fa58bb79bf149543520ba5df8555029d1a019ae9955d35196b0097428dad7e"
    sha256 cellar: :any,                 ventura:       "df821e88530d463b75db3ca8038c1232713d050ec2f65511e3f06cd7872b370c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c215ddaef3d961d77f9ddf87bb0900254f93e257554fdb5c86e59ae1749c45f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce24804de36ac3aec98b9f9a0ac68205e3df1c89bade179106ab7fe485c74bda"
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