class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.14.3.tar.gz"
  sha256 "fcfdc4d62d907278e040e43609f5a37fdce0c2fddb67d03ec6b2a8f9c365f072"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cde87b2c7348c5cb54d7fb45f81493593d27737b6e402f30487d43a6c5b2af3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "120be548d14c3cfec1a68724256c4922fd48ac72b0fc300aaf34b23a2aef8c3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c7d7dac6c42e1620d454c7420aacd30c4017c98f249cc83ffcd6dc6a00f1d8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cb8847fab2447db5e22809a7a5caccff406a5c7501171e76a1b287eceea6eee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f10293f99eb21c2fcf84baa5e05388321f2bc46b65d283e2e522df483736a121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a194ef449ab70f39185f298cfbf3986d0a01ba0c9b7d6e45fb8861a29a35fb7b"
  end

  depends_on "go@1.25" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/onflow/flow-cli/build.semver=v#{version}
      -X github.com/onflow/flow-cli/build.commit=homebrew
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"flow"), "./cmd/flow"

    generate_completions_from_executable(bin/"flow", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin/"flow", "cadence", "hello.cdc"
  end
end