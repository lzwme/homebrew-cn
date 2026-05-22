class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.17.2.tar.gz"
  sha256 "48f87477ddd4d0b09f51a524220dc42e62cd9d2c9c902ace181ee37f4fef5235"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2847fdb99e716009f0bfb75e17c5587f600479481dad49dcbb7c1fafe3f0d272"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c58a2e44f25062a5a031c25c93717fa972eacff0d74a0b35c6e2caaa320ca3b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71b90e0515ad2fe079838786dc95ee59525e1b3544729e3951975ba7d5e65705"
    sha256 cellar: :any_skip_relocation, sonoma:        "29f0d3858701607d185f33041930e7b42e9aeb1e4085a81610f97bfce9d76863"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcd1e1df990782e4cc9629294c104f296515d1488168a923ea494f4ffd560948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94aab95cc21fe85def323524b52968b5681306d9dd97ccb775e631b4eea29fb7"
  end

  depends_on "go@1.25" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flow version")

    (testpath/"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin/"flow", "cadence", "hello.cdc"
  end
end