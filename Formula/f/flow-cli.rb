class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "dc9b4c89baa0998531a049a30ecd4224decf741cd25e9e636a65aeeb87e28669"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3f1216b055c5ddd0ce493739a767844f95163d4d1bc94eea1de2b06a2986dd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f067080c76cea1aef238c739d1a0de1ca4999c81fd90cb8f808d8241f317013b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dff9027ca3d88f126ddcccb0b299e09fd54a00a07239b7362328484d695fa97"
    sha256 cellar: :any_skip_relocation, sonoma:        "065ac2fe4c9bf4a0cf53478eb3680b82e655c9edb7c1935a371c4c4d6720f20e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80cc486b2ea4a9f8f510a1b9eb3b3954b653dccdaae4ddcf1bd406ec90e4da7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beb54c8b0e642123016d369e9299f1642459165ae07a40542dae0b1b0e4a9878"
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