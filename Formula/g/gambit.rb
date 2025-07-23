class Gambit < Formula
  desc "Software tools for game theory"
  homepage "https://www.gambit-project.org/"
  url "https://ghfast.top/https://github.com/gambitproject/gambit/archive/refs/tags/v16.3.0.tar.gz"
  sha256 "d72e991ce935a3dc893947c413410348e2c2eb9cd912ec3b083699a4ccae4d77"
  license all_of: ["GPL-2.0-or-later", "Zlib"]
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c91f56e59b93918525432ef6d7c4de508e285c6242327b41b0e7f764b18e6f79"
    sha256 cellar: :any,                 arm64_sonoma:  "38770b102e6d03756573dc1f3dae3300cf34dfdf3ccb34e2f9a5e53a8d42514b"
    sha256 cellar: :any,                 arm64_ventura: "6ff6cd41a4208309d0dfd948cefd1caebed476eb90a3472ca2138ac16b0ac46b"
    sha256 cellar: :any,                 sonoma:        "89d98e9c663d56223ceeaceb30861490f597ba6c6575ab091c1e1f04b773aec3"
    sha256 cellar: :any,                 ventura:       "2f388da13334d5cb6a951640cafd203d80e120047ae2604a2ae016f6c0c4ac87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba82accc53322452a615c8ac767afdf3758f8f71a938139c3109a367a2007675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d78c91153188424cd7adf8f1230c11fc353d25d6db63363b4db816b737654c4"
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