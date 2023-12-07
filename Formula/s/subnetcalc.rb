class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.nntb.no/~dreibh/subnetcalc/index.html"
  url "https://ghproxy.com/https://github.com/dreibh/subnetcalc/archive/refs/tags/subnetcalc-2.4.23.tar.gz"
  sha256 "cbfdcc54991cacb91adc652cb5f03b3ed975da0f574ff3f96f192c6046dc0e34"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6dc971e4befb039bd4b84a152e6cdd4e52d875c45842b1612d39245df7d40809"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c95445e6a8172c0a9ad51750ae5bbd677de19a61cba0a6537e7cecdf5d7db0c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a4d19c85d4cba94c98fceb56d537981c431d87ab11201b0a4af86d245cc13b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c3c3343f86552062b6a8af07058aa56641512fd424cfdee515ab8d9574201fc"
    sha256 cellar: :any_skip_relocation, ventura:        "5377b89fca83577c894fe4ca93bbfc1760cde07ee515e6f5d51566a0160c7078"
    sha256 cellar: :any_skip_relocation, monterey:       "0fb9a13243122e30633366cdc62ba401cc80d3a127c5007218d332c464c99999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e8edf85936558c5dbe251453c4bb1540e69b681b25c5d085d2b7e327605e643"
  end

  depends_on "cmake" => :build
  depends_on "geoip"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    expected = <<~EOS
      Address       = 1.1.1.1
                         \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m
      Network       = 1.1.1.1 / 32
      Netmask       = 255.255.255.255
      Broadcast     = not needed on Point-to-Point links
      Wildcard Mask = 0.0.0.0
      Hosts Bits    = 0
      Max. Hosts    = 1   (2^0 - 0)
      Host Range    = { 1.1.1.1 - 1.1.1.1 }
      Properties    =
         - 1.1.1.1 is a NETWORK address
         - Class A
      Performing reverse DNS lookup ...\r\e[KDNS Hostname  = one.one.one.one
    EOS
    assert_equal expected, shell_output("#{bin}/subnetcalc 1.1.1.1/32")
  end
end