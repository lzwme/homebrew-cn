class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.nntb.no/~dreibh/subnetcalc/index.html"
  url "https://ghfast.top/https://github.com/dreibh/subnetcalc/archive/refs/tags/subnetcalc-2.7.2.tar.gz"
  sha256 "a566b63ef485e3923d3392d42a9264e54697050d0775023763981a156e50c1f0"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "721a1770439c05ea8aef5daa8df925ec21cd7e4c8cd4b41f935d3a00d5413ba9"
    sha256 cellar: :any, arm64_sequoia: "11d2dbd6d763a30a378dde3f08a293c77079667bdeaefaaf63fb77bdfaec285e"
    sha256 cellar: :any, arm64_sonoma:  "8210e1899fb62432e9adff004c9a4512f4b9e502b90c5ab793fa22a65d6884df"
    sha256 cellar: :any, sonoma:        "5e8f3a449bb67e17ef9dd763d0cc9eea603fa4bbe7210ef062b1f51c477daf1f"
    sha256 cellar: :any, arm64_linux:   "498c19b27fa0d6685416087f06d51a44a1c5b24f364cb01aed542d5790ce6c9d"
    sha256 cellar: :any, x86_64_linux:  "42529b340926f0c64a789fe9ddc4ab36f0f3c8bf2dcc2e2a9efa6ad3af298e15"
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