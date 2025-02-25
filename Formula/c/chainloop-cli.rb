class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.172.0.tar.gz"
  sha256 "f23f907dd6e1303c1ec67269508107dbdbb7886f3873c63f8d65be31696da782"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fdb6cd74b979a1ca24ce1a134f353edb1620f9440b48e3f33a4e441797cec2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fdb6cd74b979a1ca24ce1a134f353edb1620f9440b48e3f33a4e441797cec2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fdb6cd74b979a1ca24ce1a134f353edb1620f9440b48e3f33a4e441797cec2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f10c745c58bd99df85d3928a54fe763b78dee77446561c71fdbc66a036006c2"
    sha256 cellar: :any_skip_relocation, ventura:       "2ccb1e3b904f0011210c92e558005330f796c3efc5d42d64cd7af44c419d594e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "277f5a91b33c9dc92c0bbef1d19d1b6836d36b5e96647cc5a7f5eafa47e6ced6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end