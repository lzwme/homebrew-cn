class CoreLightning < Formula
  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://ghproxy.com/https://github.com/ElementsProject/lightning/releases/download/v23.11.1/clightning-v23.11.1.zip"
  sha256 "3c7e6f35a41650ff6588a3a235726760f5a7e8b3c1c3af977d3e0abdc5dbe0a9"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5d25393ff7d4d3ec6b1342ef8d29a9d989bca9629cd2f07da6ce07cc55184c1d"
    sha256 cellar: :any,                 arm64_ventura:  "2f7bce3f3c4f0b7e7f4e3dfc512816aafff28d48bb5d425b0d17238f384753ee"
    sha256 cellar: :any,                 arm64_monterey: "ca810c663d7d9bd38d183b76b3deede49e132866e4cdc867293a656ffe3e617c"
    sha256 cellar: :any,                 sonoma:         "96732e7e5007ad6bb09eeb503140d2e2d814b85e0b2e8fbc89dcbe5c93e61c5b"
    sha256 cellar: :any,                 ventura:        "1ec9f93fda5d18cea2df612946495ebc9dea2168bcd997ba4e77f0617502cbc1"
    sha256 cellar: :any,                 monterey:       "0a05e6a1617149160bb82e02077074b32b38a7b5a78f2916398a10fb5f59d355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12d786c701c793625c603e4da87e676914e173fee4a6ec4b36ed715617a43059"
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