class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://ghproxy.com/https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.17.02.tar.gz"
  sha256 "8461a8d4d0366f5e32aebc05defbf374a118ec2922a094f4f8eea73aa7f1fee1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb3a395a35f4efba8ea4cc5c8fe7cf3433678ba3e1cd0ea085404c80534bdbbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0a86909a9a9009bc841987c8b33b945552b72d5dc3ae88f602e4e9f7a260bae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c4bf3f2b562fcae6a9f3ce2ba253c17b2c2d8456117cc607592572edb2b7f66"
    sha256 cellar: :any_skip_relocation, sonoma:         "10ad056c242ff91f15d12b1e6fd8432d024b80ede78f86b3c30857ce198808c0"
    sha256 cellar: :any_skip_relocation, ventura:        "582788f0c9f707030677a5e99c368c9163bf66d52f578515f1744fee671d28b0"
    sha256 cellar: :any_skip_relocation, monterey:       "202ca79f663d8dabd88766805c9fbd994400cadbe07e211774a8bdb2091fe5bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "756b624f4361188d53e29d58e9a14f8041432fbb97ea9b47cb430f192c8860f3"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end