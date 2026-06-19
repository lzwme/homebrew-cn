class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.100.12.tar.gz"
  sha256 "f5b6c7937369cc1a7f96e5cfe5d11e52f028bf22594c064f736ece6d92f844f5"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fa3ee50abd8c05a14769372f5d828ec47a690d85ab97f1c823f018c411ba7eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fa3ee50abd8c05a14769372f5d828ec47a690d85ab97f1c823f018c411ba7eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fa3ee50abd8c05a14769372f5d828ec47a690d85ab97f1c823f018c411ba7eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3f57902986596c26024989b4de5a7045e5cf51c175d39bd915cd0cbfa7795d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2d2b78af1f40208ebc2fd0f1bc9b4b4595e523eb655b36855438190e24cc85f"
    sha256 cellar: :any,                 x86_64_linux:  "a8054af3e1d57b29699c5ea600929f80d5f6a24f6ade9912eb33a7e95ab0d876"
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
    assert_match "chainloop auth login", output
  end
end