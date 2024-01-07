class Trader < Formula
  desc "Star Traders"
  homepage "https://www.zap.org.au/projects/trader/"
  url "https://ftp.zap.org.au/pub/trader/unix/trader-7.19.tar.xz"
  sha256 "eefc52f9e6ed7e86cf5fefdc17a8cd7b4a218a36b41468bb0edf7bc7d34cc9c2"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?trader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "c7a60ffeab56ec45489867eba1ac1ee37d707be5210d6ff033620d70e43fde62"
    sha256 arm64_ventura:  "cb1c36d5766e3e574084c4411a3427fac06c3a464c418fe0f375a9d75434370f"
    sha256 arm64_monterey: "3c15678c9f693132e4f7238da4fe8233edb1717f53442e534389341ac1ddb62c"
    sha256 sonoma:         "cf2515f579a4c567fad7be68ed6b02cd93626fc97c8bd0ee5a75eaf63303c835"
    sha256 ventura:        "da85848b2faffad4756a5744f2095366db2f8b4258d20d8b4e93dd5bdd4e81bb"
    sha256 monterey:       "b8eab4dfad300ff86e2c7950b20237858e91a4035fcc18f3bbc9687234c185ad"
    sha256 x86_64_linux:   "b678b848acf6644ed3e56c6e9fd0d009b41e1606343eba85219f817dd92cbafc"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses" # The system version does not work correctly

  def install
    ENV.prepend_path "PKG_CONFIG_PATH",
        Formula["ncurses"].opt_libexec/"lib/pkgconfig"
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-libintl-prefix=#{Formula["gettext"].opt_prefix}
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    # Star Traders is an interactive game, so the only option for testing
    # is to run something like "trader --version"
    system "#{bin}/trader", "--version"
  end
end