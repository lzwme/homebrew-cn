class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.109.3.tar.gz"
  sha256 "0709da7c5e7249921c6dddfc8010a82b990cf34280efce5eb4b7054fc02f4314"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8766c862d47c7c9406753b6452d0b7c01914340addbeed541b073a45918e2896"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8766c862d47c7c9406753b6452d0b7c01914340addbeed541b073a45918e2896"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8766c862d47c7c9406753b6452d0b7c01914340addbeed541b073a45918e2896"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7ed5c3ab8fcf80a7e0aeb97e79eb9fa04fedc54dbdff57c78bcec6a8f6f88ea7"
    sha256 cellar: :any,                 x86_64_linux:      "a91b39db14ca2562f9b1354c084b762a9a38d16b533e8069450baef4a26f1b15"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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