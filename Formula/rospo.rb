class Rospo < Formula
  desc "🐸 Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://ghproxy.com/https://github.com/ferama/rospo/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "33b2f9f31741cabdee8d96bf7bcd3b14d7ba120f02873fe31d2d3622131f0fef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5780f1d942c92ab47fb221d5b80b2f0ede0fd1e89ee8759d192cd86f9a74954a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5780f1d942c92ab47fb221d5b80b2f0ede0fd1e89ee8759d192cd86f9a74954a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5780f1d942c92ab47fb221d5b80b2f0ede0fd1e89ee8759d192cd86f9a74954a"
    sha256 cellar: :any_skip_relocation, ventura:        "db4dab5a0ddf7d4e7de8da90615a2bdb1a91e2ff7fd3bdba27d37c8f7085bb3e"
    sha256 cellar: :any_skip_relocation, monterey:       "db4dab5a0ddf7d4e7de8da90615a2bdb1a91e2ff7fd3bdba27d37c8f7085bb3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "db4dab5a0ddf7d4e7de8da90615a2bdb1a91e2ff7fd3bdba27d37c8f7085bb3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af0686313b57bc52ff4def51b7120699eb71bbe092dccee92c9d593662100286"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/ferama/rospo/cmd.Version=#{version}'")

    generate_completions_from_executable(bin/"rospo", "completion")
  end

  test do
    system bin/"rospo", "-v"
    system bin/"rospo", "keygen", "-s"
    assert_predicate testpath/"identity", :exist?
    assert_predicate testpath/"identity.pub", :exist?
  end
end