class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "313819da700c14bc049ecf5ebb7d0b8ea0efc9f269443836a317ecae428e284e"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e18e082ddc0f992cb8bd48a1a4608e60209065b0d437c19b371cfd136596957"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ccef6526bb9a2b760b08992db3eb3e0aa7da3c72daf792b61485e745a622fa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62e2c3842ff9c6ed7e1986f8bb042e3451c5a2034b9e44852ae0a56849216cfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c797bc59f6be754fbecd5d9ac5f188ac949d23c510d6dd706f2ce9b7f5b7aed4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "447b3f223a1e62c94bfd7834f69a340c1a71660d9a596c6ef69e622a8dadf709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "889976c129fa853a0a97935aca7a1e23df6aed9f369a977173b5129c0798f74e"
  end

  depends_on "go@1.25" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

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