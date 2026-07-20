class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.104.6.tar.gz"
  sha256 "dbd8b8a1a44255b57c0acfab6e7e8ed13b0a625872794af2b46d54230e977c73"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "486920c517c66452cda3095b7a25f7ca63e64efeae15c56fe06bb3b71cfa2bec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "486920c517c66452cda3095b7a25f7ca63e64efeae15c56fe06bb3b71cfa2bec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "486920c517c66452cda3095b7a25f7ca63e64efeae15c56fe06bb3b71cfa2bec"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcbadbaaabfc7b31a52c18a6a3ebc7275929b90daf141530c1165425847fec18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95566c1ca22e5b72ec1a05864ceaa7b1e26592b7c0827b8a98217ec53f4e4db4"
    sha256 cellar: :any,                 x86_64_linux:  "9f8aa8a7b809ca4c92f0b97de763f90d7f7907a8d2b3ec0a2e72d5993a0eb39a"
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