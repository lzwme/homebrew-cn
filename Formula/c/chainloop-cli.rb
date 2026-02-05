class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.74.1.tar.gz"
  sha256 "c2c5ad80f27340ce9aab46af0dd61cd2ed2ca5faee38b49b9d722a3f18370380"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abd7f77b320aef71ff4769a970d02971114c1e0266ea047ef0707e8d058e1f6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b18fbefe8de427c0a91b76fc177636176841ebdbd87af8350818af42d1afbdc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cc76ca6519c66b00f67ac069f3b99a3b2c439fe31a290b9ce9161db3b5a3436"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c569825b417394718f3ada37612428ab7726d2d4d44680e0f399059bce175ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36ad16e08d2afd5e691bdcd95113c2f9798411ea641b8f50b442eba1d04e35f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "303269b33ced6a347c1a1ebb4034a69f51653cb89b0844a9d11714c3b5948fa9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end