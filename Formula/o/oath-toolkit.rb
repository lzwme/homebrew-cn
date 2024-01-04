class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.10.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.10.tar.gz"
  sha256 "86c27224f7d6d7dad47a4f6bee65f6b884bf5bbd15c5e98cf2cc69625dbf2391"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "19c6c67ddc1996c313e35d23835b1341231cbfeda486ab1750739c87b06df6a7"
    sha256 cellar: :any, arm64_ventura:  "5d12afff13ff925b0296ff1eb00a1a74fc5e5c21f6b7f57d36e12763c1f456cc"
    sha256 cellar: :any, arm64_monterey: "62fc4d4ce7491d8bbee7ea4e81ec7ed7adee9705707a19f3af49c561d680da99"
    sha256               sonoma:         "d2670043ccad367b071dabab061bfac015123d3d9971efc4826bd533490ae426"
    sha256               ventura:        "1a1ab31cea0e46c85a5e1d739ab49842ae98d6c08164727c70a825fa36ab45e9"
    sha256               monterey:       "d35646a94ce759761fd443aeb3814c2cbd7dc40fc80517933776cfd2201d2c18"
    sha256               x86_64_linux:   "a1da1855f9c780b4b9bdd76fccef7aedbbf37d8fa0c1d8e37029db05290e4456"
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