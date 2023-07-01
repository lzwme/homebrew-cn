class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.7.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.7.tar.gz"
  sha256 "36eddfce8f2f36347fb257dbf878ba0303a2eaafe24eaa071d5cd302261046a9"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]
  revision 1
  head "https://gitlab.com/oath-toolkit/oath-toolkit.git", branch: "master"

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "c4904f8d230ac972b49388687ff2113055435f64d82d7cfa53594c907e9a55fb"
    sha256 cellar: :any, arm64_monterey: "12e499fbe35d8d0af00dd4b481f3551571e0df4ebe061a730a1c91e3fc17e680"
    sha256               arm64_big_sur:  "70e47d792b5442204e46a4d6afd2a99fbf185494e0924d969bdd209a30179cdc"
    sha256               ventura:        "4eb03fed85048f55ba0f3726ccc0b2abc7d7f2c9a69b7199ced771f70d85a04e"
    sha256               monterey:       "802b854c2c2a063610fd10d00e15548030794766f704865a7c81eec513dca4ad"
    sha256 cellar: :any, big_sur:        "991861b4c252151ebee48befa21f53ab2c50eff47832f0b5dd4b29b74d9d5c01"
    sha256               x86_64_linux:   "246895b0bcf47660f9dd3c663dd39bfe893bc98fa7a20787df1737d86652a1a2"
  end

  # Restrict autoconf, automake, gtk-doc, and libtool to head builds on next release.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gtk-doc"  => :build
  depends_on "libtool"  => :build
  depends_on "pkg-config" => :build
  depends_on "libxmlsec1"
  depends_on "openssl@3"

  # pam_oath: Provide fallback pam_modutil_getpwnam implementation.
  # Remove on next release.
  patch do
    url "https://gitlab.com/oath-toolkit/oath-toolkit/-/commit/ff7f814c5f4fce00917cf60bafea0e9591fab3ed.diff"
    sha256 "50a9c1d3ab15548a9fb58e603082b148c9d3fa3c0d4ca3e13281284c43ed1824"
  end

  def install
    # Needed for patch. Add `if build.head?` on next release.
    system "autoreconf", "-fiv"

    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "328482", shell_output("#{bin}/oathtool 00").chomp
  end
end