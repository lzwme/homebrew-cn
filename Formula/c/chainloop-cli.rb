class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.111.3.tar.gz"
  sha256 "a115a677865c9185a2395b96ea5c88204807e7eb19f1d8d51c78f2751acfc1c2"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "443c76671575939a90961ce9258be05a7f7d53a0f00b9dcf39e16130c7e50e04"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "443c76671575939a90961ce9258be05a7f7d53a0f00b9dcf39e16130c7e50e04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "443c76671575939a90961ce9258be05a7f7d53a0f00b9dcf39e16130c7e50e04"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7096f6a45f95d0e3d7d7b20f16d802f4cff1eabd0b74f6944d80a6b47b63e997"
    sha256 cellar: :any,                 x86_64_linux:      "53fec6f51223cde42a1026d0c7c0abd21da309c82bb33873ef8c15d73f52169e"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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