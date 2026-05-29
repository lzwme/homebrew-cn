class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.nntb.no/~dreibh/subnetcalc/index.html"
  url "https://ghfast.top/https://github.com/dreibh/subnetcalc/archive/refs/tags/subnetcalc-2.7.0.tar.gz"
  sha256 "193a5b182642952eecc8aee162324b27b227fd57527b6f71297d428a664674e1"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3076ab0ce037ec2d338a34957f5493381249ebdecf5b0e1c2d677b86199d886b"
    sha256 cellar: :any,                 arm64_sequoia: "37843dde6199ff2baf60ca1f432cad8c770e6b5479a193184c57a417353dcac5"
    sha256 cellar: :any,                 arm64_sonoma:  "66d0045104b990b56bae7af2f3c64a7de19397b0c3f73aa26896e071491728da"
    sha256 cellar: :any,                 sonoma:        "818ec1e44412b726cf100ba48f90849f14d690a0af606cda7c2706cbf2b83ab5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b24c92e3f69f966589be34907e6741901b618883a3ba4cf2675ebb6910333051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8f46fcaf47c5359d30d61bfcbe70a63ae9afd65edf6e79012fef9f8cc531bfe"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "libidn2"
  depends_on "libmaxminddb"

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
      Network        = 1.1.1.1 / 32
      Netmask        = 255.255.255.255
      Broadcast      = not needed on Point-to-Point links
      Wildcard Mask  = 0.0.0.0
      Hex. Address   = 01010101
      Host Bits      = 0
      Max. Hosts     = 1   (2^0 - 0)
      Host Range     = { 1.1.1.1 - 1.1.1.1 }
      Properties     = \

         - 1.1.1.1 is a HOST address in 1.1.1.1/32
         - Class A
      DNS Hostname   = one.one.one.one
    EOS
    assert_equal expected, shell_output("#{bin}/subnetcalc 1.1.1.1/32")
  end
end