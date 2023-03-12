class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.11.1.tar.gz"
  sha256 "3aad445f754f0c4e98c54c8595d54f75e98314dfd3570467281c25bba100541e"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0f1133d4d0d5016cfac20a84a9c6caff0eeeabbe5f0c611b92ba6491aa289afd"
    sha256 cellar: :any,                 arm64_monterey: "4ad4535de36ec6e586de7a6f7bbb530231f64e5ce0d3971aab84f5db907880d0"
    sha256 cellar: :any,                 arm64_big_sur:  "f1969c697498001fead9cf58d04b4da94c5c4b0124c5aba3e4df01d911ab0cd7"
    sha256 cellar: :any,                 ventura:        "a1dbf81b40e7492d23a5efecdeb3b9e341357ff5c61dd2ce5b7e99c5520aa6d0"
    sha256 cellar: :any,                 monterey:       "c8222dbfec7b9440d465ef8483559c9a0fb7287b56562a5b4ef686cae61ca0ba"
    sha256 cellar: :any,                 big_sur:        "25fd1188954bc4abe90ce10f54fca23f36527307d3a37f55fffb7fed8038eacd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4aada5f82e1ee94b12ce674c32092748d443527b0da37119f7c13a99e3639cec"
  end

  depends_on "pkg-config" => :build
  depends_on "concurrencykit"
  depends_on "ldns"
  depends_on "libnghttp2"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dnsperf", "-h"
    system "#{bin}/resperf", "-h"
  end
end