class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "b0318e80b13b3ebbb5235a15a3b4c0265024ad80d0df26077ca33b483ccc1ba7"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49996124a98e2f077c23c8d1115521ac3a896a7b27c9dd2ee9cf552509512d54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7308b6b1f3239f047cbef83635e940d12f62421d0b9e8705ef6489f40f159303"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb0d817ee2a1b75a33b717e68f65c5946b5e2ec27d2a47ee94c794baa463cc84"
    sha256 cellar: :any_skip_relocation, sonoma:        "92825432b7582c8d572ae378a3cd6c6829bf9c23ec9b1c3c4bbf79c8ff42e0a6"
    sha256 cellar: :any_skip_relocation, ventura:       "706ed2848678439c4dc2d87ed3d312f32e0df0db0a44ad7f1fff7bb37ca6af99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ace6b89b0d050053a9c2fad33a9343553bbb54d8ec9f1b6b55d7cb899af9518c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end