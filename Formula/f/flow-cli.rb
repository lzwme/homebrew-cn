class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/2.13.2.tar.gz"
  sha256 "2906c00f8c10867bcdc2fff8e153a3f08be3d394c24dd9c91ed97bc95e983b5f"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a984cc1df488c84ec3492dfa68f6097f8022ae8b46e85fd915d72fa1b823161"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04fe5a4c37a7711bd52bdce871742ad59ef78114c0898e9cadae32c077cda136"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79730f643f63a744b1cf9909f305950279886524763cf3c6f117bfae58cfe9fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd66849058fe9ad3479dd253991882fc135d6cf2efba99f28e0c393aef6dd5ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05a355ab8742388c3eec7bebde973d8b539dd94e24f05b468706369ba90c1b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "450bb68839dd5edc5776a24e8dc89ad20dd99b8b8a2295bb720b85dfbb4c9d6f"
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