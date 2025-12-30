class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.13.3.tar.gz"
  sha256 "a79de946c606c8d5fae6e1b82f9921b961709fe7f648f522bf4f5c2f1076d597"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "334cbff336740a29ff925030d86766a9f188e3ad272cc4440b47de73812dca5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd02e6ec3660df263b9826b4a1bff3100fc813d4d774cbd195637b427e353c7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3943f02c565b7306560687b6b874c48d64c9931bcb60480b16f1547e17b656c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "85bddc9e1a03c4d0f6bfcb6748fe5b8d26dcf62f955465789a8de6ade537865d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3fd2c52be4904068655f28e39f190fa77d61fc6e0efbb6947ad4b68043ff5ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "539d7cc51ae74d4618cd6bfaf5feeab619a922a6e4af236a4393888649c42418"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  # bump cockroachdb/swiss for Go 1.26 support, upstream pr ref, https://github.com/onflow/flow-cli/pull/2239
  patch do
    url "https://github.com/onflow/flow-cli/commit/bec1ee457616b9e39552bc15dc1d0370472445d5.patch?full_index=1"
    sha256 "95c667fd71df39479f3368d5400351d47c3a870592497daba484f38efa88d446"
  end

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

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