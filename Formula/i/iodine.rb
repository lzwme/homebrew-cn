class Iodine < Formula
  desc "Tunnel IPv4 traffic through a DNS server"
  homepage "https:code.kryo.seiodine"
  url "https:github.comyarrickiodinearchiverefstagsv0.8.0.tar.gz"
  sha256 "ffc7a58cdde390a01580f4cfc78c446b0965bcb719bde2c68c5e0c27345a8dfc"
  license "ISC"
  head "https:github.comyarrickiodine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6137123041fc9cc12bfb1ab7b5c89db1df5a8a53c46005894ed3a2928cfd0ed2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d366cab32fff89cfe558c7b03fdf36931a100e2834e6d830a642cb4517eb5e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c56442257c490693ec92dce6ecf8b579c630460843e1bae51f46f48116a7e316"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d07879633a49ec8f6dcaf65514c71409acdc9b9a92b05872ed02581ddadb999"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec5682669fd55f55ea306f36d07d84cb69b19bf6fd295e18b3d161a4c32f43ef"
    sha256 cellar: :any_skip_relocation, ventura:        "e1162e6eb9ee5c0579216e80af32079d36adde37fe4653fb6da34a58d54e7c3c"
    sha256 cellar: :any_skip_relocation, monterey:       "297d884daa963973050eb436c9727c850ffce5627a33310bd159e7e13c6c8483"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe1f5e48bcc20c66d29ce945f72d7879ba59eec5af18b3fd46ac3c21c40c6319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eef2dd9635b68cd36d2d7e3d1225d0644205250b5600874ad381d8b94a7a5b06"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    # iodine and iodined require being run as root. Match on the non-root error text, which is printed to
    # stderr, as a successful test
    assert_match("iodine: Run as root and you'll be happy.", pipe_output("#{sbin}iodine google.com 2>&1"))
    assert_match("iodined: Run as root and you'll be happy.", pipe_output("#{sbin}iodined google.com 2>&1"))
  end
end