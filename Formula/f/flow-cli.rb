class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "f761db36db6c0867751d9f248ddc89c2504f4c85f6228e68efbfdf1cf6e4d111"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de5876c3634d739e7a4f5d3346d7db1427b25c065ab5ce685ea6a605ea175c75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f6fc6ce9a922b71b27e7413dbbff5202d875947c9d99be7b9f3fff33b17fd2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b6d9a05e57de20aeaf44dfdb93fcb3a2d7f1f1311a1d9868aa4e0344149137b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0dbb28c794828bda35bd3ec2b04ac1986857b0883e841e6fddbb6b5e19fd6ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3313f83e215564c0189c0ff4b19a7805b1c328f79010c579e4337dcbdf0b37f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dcc25ddb60d8b0b718cc4a7b6e22a0628f1b0677858ed35f947201b9fb46497"
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