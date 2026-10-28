class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.128.1.tar.gz"
  sha256 "b9d2d43aaf17933043443c9fb4dd6277c3fc1e32923a6135ee578d612f70d50d"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "472214408d96793efbb829cf6e8ec35ca5e83a730c9bb73fbb2846fa7e70bd61"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "472214408d96793efbb829cf6e8ec35ca5e83a730c9bb73fbb2846fa7e70bd61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "472214408d96793efbb829cf6e8ec35ca5e83a730c9bb73fbb2846fa7e70bd61"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ff09f1465e881bf2123bb5396ef533abd9fd1d4480526c26d00c4e7b9e8f8c79"
    sha256 cellar: :any,                 x86_64_linux:      "7637daa952b7cb2d374340d4760619eda2a2edf221359f5d4f497365b0b002fa"
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