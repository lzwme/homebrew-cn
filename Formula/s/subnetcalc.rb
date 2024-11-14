class Subnetcalc < Formula
  desc "IPv4IPv6 subnet calculator"
  homepage "https:www.nntb.no~dreibhsubnetcalcindex.html"
  url "https:github.comdreibhsubnetcalcarchiverefstagssubnetcalc-2.6.0.tar.gz"
  sha256 "61722297f70ad3a5fe4d32a95b5a8652f7f8146797400703b32b177e2046a492"
  license "GPL-3.0-or-later"
  head "https:github.comdreibhsubnetcalc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1d1038290d64ebe1518b9884c3da20e8eb9996ef84abb0a8fab9f6f404c01792"
    sha256 cellar: :any,                 arm64_sonoma:  "2f2fe0db8a51eb8b2ab0ca023edb17c268cafc3b58941c420f7790e146400f5f"
    sha256 cellar: :any,                 arm64_ventura: "40d8d45fb3f15d9b075b0c0cda03b723c7a650535138d63d5870359ce83afa25"
    sha256 cellar: :any,                 sonoma:        "2f3d59e8bdac16a887e930743e7210c7c41ab5905c9cbd402c744f4da0da78e3"
    sha256 cellar: :any,                 ventura:       "b3d3d140c15d5bb3e2c3dbb7506b1b0b02400922515c472b3188a188b8a0f7c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "733f08d71df968f3895872fcd8b81fa23fc536f6f101b9fc2a30c40fdb6208d7"
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