class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.6.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.6.tar.gz"
  sha256 "fd68b315c71ba1db47bcc6e67f598568db4131afc33abd23ed682170e3cb946c"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d56bf5ebe830d184b5ead115d5cd6cbd99e841ecc22bdaa1eb95acc7c1205dd7"
    sha256 cellar: :any, arm64_monterey: "e625bb0ce23aa527527c3edde57e7ac2c3636818058d78df3d6d6365ce5d54ed"
    sha256               arm64_big_sur:  "717b1353b92a3014f89cd9d70d1fde81ea8d72105bc2f7664e2991873b7f995f"
    sha256               ventura:        "7a9b25b290e753ce832993af349c3b9a6082b54ca622e5bf3762f7f917830b3d"
    sha256               monterey:       "1e835161792bb992feba1db5e19c662de011357c85cd1d1beb29c7fd60994e41"
    sha256 cellar: :any, big_sur:        "ed8dd264bf39ffdeff84b2ed366bb3bebcd3578081b9f5d78a9f2b05160078aa"
    sha256               x86_64_linux:   "b571a3591c7215d239a068af0b284211a7222b96af08bd73736c6c8dd08c6547"
  end

  depends_on "pkg-config" => :build
  depends_on "libxmlsec1"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "328482", shell_output("#{bin}/oathtool 00").chomp
  end
end