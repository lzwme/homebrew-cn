class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "49f932c0a4411c7389e03e49356c74069094db03e45fafc641072a4afe34c7a1"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a53e1b350c049d8e4320225e80e9449ad6fc6499e49dd2b5121fa0423b1026b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "406616141a564c6a550741bf82e149e91a01673ebce10d6e2e47f53e097e8409"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2cfea080dee164f8f746b77bc181066c70331e13a27b78f355bd00c94c239ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a3eb1dc2680541385122b271d5eb585ea5685136159f5893f1fbddb26a41482"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edf8c28df9d3a013d22da8324a0c4bc16c3b13d72664ead0b6ee2ef63b9f7e75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2b7fd221f75c9d4f021ce2b5681b657dda66e9da73fd8f1c1560f6dfa6af611"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion")
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