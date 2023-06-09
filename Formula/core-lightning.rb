class CoreLightning < Formula
  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://github.com/ElementsProject/lightning.git",
      tag:      "v23.05",
      revision: "d1cf88c62e8ff10485f3b40cddb93fc0063ba92a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6a0a9f3d12062fe4335ee9236882735e0cc65da9cd9e185dbba9d25788095ad1"
    sha256 cellar: :any,                 arm64_monterey: "68380caa6742aea13e5cd0b358bd4065649fbc04c3ad0703ff925bd51fef08b7"
    sha256 cellar: :any,                 arm64_big_sur:  "5c66f2b5b1d2094fab9c38a64691a6d9bd4babbc009e128feb810e9fa149f959"
    sha256 cellar: :any,                 ventura:        "a77fd27dd88e07740eb5a553e5881bf8f10ec1a9d2597e82cdf6ead99a41476e"
    sha256 cellar: :any,                 monterey:       "35f13f39af45a773b0297891ff7ead7122752ab332e679c272224368d2ae7aed"
    sha256 cellar: :any,                 big_sur:        "10dccc640fde1ef2a6c657dffcede0f7e0e447aa52e586bceed9d109722c19fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "136008b34be22709bca55c5953751f944543c7e39bddc3fb2504529caa51a020"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "gnu-sed" => :build
  depends_on "libsodium" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "poetry" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.8" => :build
  depends_on "bitcoin"
  depends_on "gmp"
  uses_from_macos "sqlite"

  def install
    File.open("external/lowdown/configure.local", "a") do |configure_local|
      configure_local.puts "HAVE_SANDBOX_INIT=0"
    end
    system "poetry", "env", "use", "3.8"
    system "poetry", "install"
    system "./configure", "--prefix=#{prefix}"
    system "poetry", "run", "make", "install"
  end

  test do
    lightningd_output = shell_output("#{bin}/lightningd --daemon --network regtest --log-file lightningd.log 2>&1", 1)
    assert_match "Could not connect to bitcoind using bitcoin-cli. Is bitcoind running?", lightningd_output

    lightningcli_output = shell_output("#{bin}/lightning-cli --network regtest getinfo 2>&1", 2)
    assert_match "lightning-cli: Connecting to 'lightning-rpc': No such file or directory", lightningcli_output
  end
end