class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.127.4.tar.gz"
  sha256 "38907d59789dab67d8a438797fb461660855da100e15dd9e45f73d072d25fa47"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76460fabfe9fe4edb74826a7f3756007afd769ea8a0c1bd106be1e7ec1104c45"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "76460fabfe9fe4edb74826a7f3756007afd769ea8a0c1bd106be1e7ec1104c45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76460fabfe9fe4edb74826a7f3756007afd769ea8a0c1bd106be1e7ec1104c45"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "534a470934bd17d8bfae1d0df946903f5ddcf7b95b9c3f032adfe38fb498e136"
    sha256 cellar: :any,                 x86_64_linux:      "3f6f60f78df1e6d6c7ccae91945ed8b1c35c21ea63513dcaf725cb19c4ab9625"
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