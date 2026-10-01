class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.112.0.tar.gz"
  sha256 "c76d75a6d85258ab3bb72630e0ac86883c4f885aa4cd535f1a924cf84459042d"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "180250998a72a6bd8b05189356e7d295235a2858ba52fd4cb13a893e24cf279a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "180250998a72a6bd8b05189356e7d295235a2858ba52fd4cb13a893e24cf279a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "180250998a72a6bd8b05189356e7d295235a2858ba52fd4cb13a893e24cf279a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "074b1adb1848ce4c7465fdc71f53a73b247e4816125e736b23f679726a362fe8"
    sha256 cellar: :any,                 x86_64_linux:      "047999a8bdf7cbef1c29f11b0d7161289069f4d5a5eedc75fa5d454a2673e8b0"
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