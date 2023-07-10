class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.8.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.8.tar.gz"
  sha256 "0a501663a59c3d24a03683d2a1fba4c05b4f07a2917152c58a685d82adc0a720"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "c57900aa1173ecd0690de9191a25001b97d7725a08c350f95e9abbd3579d2890"
    sha256 cellar: :any, arm64_monterey: "32fecea80a82cc7414b35b9a242b074f3092b3e40e756d87747e8074469ccb98"
    sha256               arm64_big_sur:  "28d9d4fb6912a756800e52832cf50e4feb20cd6146399a510acfc441db813d5c"
    sha256               ventura:        "336876de14bf9fb91138abf9e6183ec026d18b03df7be30957c4ecec888d1059"
    sha256               monterey:       "b6e0e2c83ba68a86e1ddd88c8f87de83d09ccc04a0236f92adbae498946dd63c"
    sha256 cellar: :any, big_sur:        "23d90cd5e3e1792a6ccafbf0fbf01488151ecdef323c1dcb1c517e1dde0f0118"
    sha256               x86_64_linux:   "3511438560a06128bc44a9fd32a8aeed30cdce6659f4f77001f489efc1087481"
  end

  head do
    url "https://gitlab.com/oath-toolkit/oath-toolkit.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc"  => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libxmlsec1"
  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "328482", shell_output("#{bin}/oathtool 00").chomp
  end
end