class CoreLightning < Formula
  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://ghproxy.com/https://github.com/ElementsProject/lightning/releases/download/v23.08.1/clightning-v23.08.1.zip"
  sha256 "3e89e0ce0afe54cae9f27ae99d1d1009aacc59404f3e34dda1e6efa56ad2cbac"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cc75f7c4ae2dc3cbbb04e573f939213da8e6d66db24138d0a5e39139ba189497"
    sha256 cellar: :any,                 arm64_ventura:  "a2b1462e1274b07f6ce7866a44b0c2f3045a4ddbbe6bc924ef19e522f4f1add1"
    sha256 cellar: :any,                 arm64_monterey: "75e6b2f118b5018d3fa1e8797a2fe16128f8729f4a7ce19d9ce38a016ba969ea"
    sha256 cellar: :any,                 sonoma:         "0658810965138b4bc9a0371bcb7cd880e56fb1f986e089c596b4d8ca05ce09ce"
    sha256 cellar: :any,                 ventura:        "ffbb339868f01112797fa865d40659039691d262d6a3abe5c124f9cd1c1b11f2"
    sha256 cellar: :any,                 monterey:       "2ed105f9d2e6072923a00a757f25a955e04a2fd3622b2a40e11e1cadbc0fb59d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61189d22785e1a954c414d247fd6955c981f64dba874233e2c9bb486b1c56c08"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "gnu-sed" => :build
  depends_on "libtool" => :build
  depends_on "lowdown" => :build
  depends_on "pkg-config" => :build
  depends_on "poetry" => :build
  depends_on "protobuf" => :build

  depends_on "bitcoin"
  depends_on "gmp"
  depends_on "libsodium"
  depends_on "python@3.11"
  uses_from_macos "sqlite"

  def install
    (buildpath/"external/lowdown").rmtree
    system "poetry", "env", "use", "3.11"
    system "poetry", "install", "--only=main"
    system "./configure", "--prefix=#{prefix}"
    system "poetry", "run", "make", "install"
  end

  test do
    cmd = "#{bin}/lightningd --daemon --network regtest --log-file lightningd.log"
    if OS.mac? && Hardware::CPU.arm?
      lightningd_output = shell_output("#{cmd} 2>&1", 10)
      assert_match "lightningd: Could not run /lightning_channeld: No such file or directory", lightningd_output
    else
      lightningd_output = shell_output("#{cmd} 2>&1", 1)
      assert_match "Could not connect to bitcoind using bitcoin-cli. Is bitcoind running?", lightningd_output
    end

    lightningcli_output = shell_output("#{bin}/lightning-cli --network regtest getinfo 2>&1", 2)
    assert_match "lightning-cli: Connecting to 'lightning-rpc': No such file or directory", lightningcli_output
  end
end