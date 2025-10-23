class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "6c074dc3fb4718b6a05cb64eed325240eb5cb85f4a0bbc33d3e5bfbd39e072db"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac0ebdf9510919cb21f158503991764680d8014d2273370e67ee99ed63cbd85f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b4ab9aeab6f7dccabc2754a3c27887e3d24701ab0e8bfc2c29185da67c7c804"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccbc98e7d629e030f57f7f97e9a0e26b164d0f1e0ae6423e6f9d9b272329d4b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "905238b7bff48273bb1ac8c0f1f0c61b4118fed923c9ee640f160551d193b35f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c40b5046fe92b90eab1914ed3c2d0f20d6b267082658934032eb1a616d6f1cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94681af1d7daf359db39fb00e2e852806407216c397d823bc789c67ea9219a82"
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