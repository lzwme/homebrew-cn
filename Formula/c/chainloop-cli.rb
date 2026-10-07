class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.116.0.tar.gz"
  sha256 "23b0808a8ad9075cbe396e636f0d2b9bde7e3fbce786b20f8f371f59e7c80577"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "62a121921a81858ef26667655f663a00f21ba25c40fe9d423e08983139e2fdfa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "62a121921a81858ef26667655f663a00f21ba25c40fe9d423e08983139e2fdfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "62a121921a81858ef26667655f663a00f21ba25c40fe9d423e08983139e2fdfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1e25ea99ebb496734af25413fd31a2023f91fbbe30ceadbf791a11add85a251e"
    sha256 cellar: :any,                 x86_64_linux:      "be2a9928cdd30edaf7e6daffa069fd50870005e494ae6363f94e2c8bd9975278"
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