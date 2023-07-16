class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://ghproxy.com/https://github.com/lmorg/murex/archive/refs/tags/v4.4.6110.tar.gz"
  sha256 "54795331944059eaf760b26517a64f30ab663e00bf42efc5348edd1037f98260"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19e38de80444a88e39b063416c8752a71ca8bf99c83e314247b14d2634fe1f7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec681e662a026984ec20ec81e8d0f83203b04a5b3dae0d43d426dd5a25185cc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69f71dfa2b7fdf777d8a0103141a2d74a0d2643235544e6264a1a4a194bfd3f7"
    sha256 cellar: :any_skip_relocation, ventura:        "b892ec8e6dc5ecbb55b0b298717139ab371c82c88e752dc0484444bcb70a32c1"
    sha256 cellar: :any_skip_relocation, monterey:       "d42cf2148d06026a00162be5cffbe1a102b141ea0d549baf712e41c920097f5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "600614f96453c725afee5b46868f59a2efba08bc47a58ecb539d28747129213c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b996b1102ee8a241d0dcb4e2251a05fd7a61a5e0620b60d53dfa47b3be482a1b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end