class Subnetcalc < Formula
  desc "IPv4IPv6 subnet calculator"
  homepage "https:www.nntb.no~dreibhsubnetcalcindex.html"
  url "https:github.comdreibhsubnetcalcarchiverefstagssubnetcalc-2.6.1.tar.gz"
  sha256 "34e4aa8dc3fa27d2c0b000d5a3c5752e15d6e33e8afce28883d1dacf0b3f5a0d"
  license "GPL-3.0-or-later"
  head "https:github.comdreibhsubnetcalc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "619ebe5ca3efa57ea4950558ba93e165aeeb037070d9f4905de83fe7e9c2fd81"
    sha256 cellar: :any,                 arm64_sonoma:  "7134e0281e91a3735ec3be6ef9e2bcdf7f5af2c2c187dcfb508f6302a91f4324"
    sha256 cellar: :any,                 arm64_ventura: "b67ba68473b08ff8f38a7736d647f6edab2a67fabb5aec3b853737a0ec000a2b"
    sha256 cellar: :any,                 sonoma:        "7f369a855801b3c5f3d3a5db3c2ae82ba12f44f6773f1ae732cb113f181fa1e7"
    sha256 cellar: :any,                 ventura:       "50ef1476486798fd1bc5a0d88fdfa44741ad42910046d0c66920eaa17d62b1eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24a666c61ce78e175ebb7990abb8df8a76d9f6d721b19980d91375c3256e74e3"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  on_macos do
    depends_on "gettext"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected = <<~EOS
      Address        = 1.1.1.1
                          \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m
      Network        = 1.1.1.1  32
      Netmask        = 255.255.255.255
      Broadcast      = not needed on Point-to-Point links
      Wildcard Mask  = 0.0.0.0
      Hex. Address   = 01010101
      Hosts Bits     = 0
      Max. Hosts     = 1   (2^0 - 0)
      Host Range     = { 1.1.1.1 - 1.1.1.1 }
      Properties     = \

         - 1.1.1.1 is a HOST address in 1.1.1.132
         - Class A
      Performing reverse DNS lookup ...\r\e[KDNS Hostname   = one.one.one.one
    EOS
    assert_equal expected, shell_output("#{bin}subnetcalc 1.1.1.132")
  end
end