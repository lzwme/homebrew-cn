class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.122.0.tar.gz"
  sha256 "d56d5efa3e7aaae92399940ddcb7c8ce911d115b2d62fe78761a47fefb10e129"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e96cf7a337df466f6518fa014b422e2c46edbd09767a6b2bce9d78ddff64e08c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e96cf7a337df466f6518fa014b422e2c46edbd09767a6b2bce9d78ddff64e08c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e96cf7a337df466f6518fa014b422e2c46edbd09767a6b2bce9d78ddff64e08c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "16d80121e04af38fb64df71545d78112a7b83694673d43f6434cf76a6cc41d8b"
    sha256 cellar: :any,                 x86_64_linux:      "851cd6b4c28137fb39f4d8184b41700e215494b04a8f490474617bf8a2ed331e"
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