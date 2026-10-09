class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://ghfast.top/https://github.com/oasisprotocol/cli/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "e9227789981113ff6f4f7018afb65b395259904669073e254acdf8b92e2aece4"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e93f2eb540c43d7920a500d5aec2129b23cb6e06984738061cfeeac5152265cb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0afec38790a413fdb43b7df8e35a905d3bfd6099fa425c89463c678196a8f715"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "803dc16de9db22fd637872aa2cfda3979a149bb9085c44c4ec1f9dea2763a536"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "04670060c5a653acf4cee655ec056f699add7d2840300a1b96932605b98b2a04"
    sha256 cellar: :any,                 x86_64_linux:      "8b889114a227206672a2c2b1a908cccee8020db5091896ae6258dd18d516f2ad"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/oasisprotocol/cli/version.Software=#{version}
      -X github.com/oasisprotocol/cli/cmd.DisableUpdateCmd=true
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"oasis", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oasis --version")
    assert_match "CLI for interacting with the Oasis network", shell_output("#{bin}/oasis --help")
    assert_match "Error: unknown command \"update\" for \"oasis\"", shell_output("#{bin}/oasis update 2>&1", 1)
    assert_match "Error: no address given and no wallet configured", shell_output("#{bin}/oasis account show 2>&1", 1)
  end
end