class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.118.0.tar.gz"
  sha256 "0548e7d053004af5e0dbba0b4a4b7c796cc777aed5e44e4264abc74ea6b5995b"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db5f77235a6ccd3ff35dc0f73c5a7cc6cb10dff933ea89251e5e99ea8f553e9b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db5f77235a6ccd3ff35dc0f73c5a7cc6cb10dff933ea89251e5e99ea8f553e9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db5f77235a6ccd3ff35dc0f73c5a7cc6cb10dff933ea89251e5e99ea8f553e9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2c750890c524d614e0f9992110d43503a7834230231ae1a63aeab3d9aff9addd"
    sha256 cellar: :any,                 x86_64_linux:      "8b4a940d3c123cdf61e0f39ef5f8468921e69c5f2842fa8c3001548846412e91"
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