class Bgpq4 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "https:github.combgpbgpq4"
  url "https:github.combgpbgpq4archiverefstags1.14.tar.gz"
  sha256 "5cfaec098f4923965eb8e579a57cd29ad1850f5929dc1ef7aeb6a2f724d31c5e"
  license "BSD-2-Clause"
  head "https:github.combgpbgpq4.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9abebce464d0ff16718a61e4012081e5c02ac018a7e2522212d1d71a9fdb528"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c1d65d93afd788a087e78ab6781912010a4e7d353eeef7bba5e0352f7ac8498"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8bc9b9f4904bb562db28a5ce13d657dbd681a72a72eaccce7dad09f0fb44e5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c940623827042d333871cc642fad0a70a66363eca29990b30adbb49b13956143"
    sha256 cellar: :any_skip_relocation, ventura:        "49954c937a68ddc0cf9a7c587119c60aa58e32e4a0c470b89409de0facc71409"
    sha256 cellar: :any_skip_relocation, monterey:       "0156107f03cc9fa9d2e7d3ccaeb8fe834664e10279a7a129dd8919dd0c4c64dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "107bb6cec5d024700710c2ff274f5a9224d4b9f432020ee8c95ecafbc4de011e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system ".bootstrap"
    system ".configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = <<~EOS
      no ip prefix-list NN
      ! generated prefix-list NN is empty
      ip prefix-list NN deny 0.0.0.00
    EOS

    assert_match output, shell_output("#{bin}bgpq4 AS-ANY")
  end
end