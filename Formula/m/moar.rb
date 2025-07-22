class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://ghfast.top/https://github.com/walles/moar/archive/refs/tags/v1.32.5.tar.gz"
  sha256 "998d5a3b01b878a9af23faaacae661d1c86c800715d6af2011a5a3f5c477b3fc"
  license "BSD-2-Clause"
  head "https://github.com/walles/moar.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4245ced73c515be0327b3a75bfe10802bac295fbbb605c51210e4a0ba805c0d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4245ced73c515be0327b3a75bfe10802bac295fbbb605c51210e4a0ba805c0d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4245ced73c515be0327b3a75bfe10802bac295fbbb605c51210e4a0ba805c0d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bc666349058f5bf7fefa0cdf4087d5e15385a933b39f485ce6df66603b6ea02"
    sha256 cellar: :any_skip_relocation, ventura:       "8bc666349058f5bf7fefa0cdf4087d5e15385a933b39f485ce6df66603b6ea02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0df587849b752ff6492de3df5e1afa9b669329aa7d686429f7e23341da94c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a4a6aaba13cf8f0cbb678078d138feab56dbe8758ec5c290547336cd0617ef0"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end