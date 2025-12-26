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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd6cdd1eb2124d772b1351fa9e62166a46b0bee057bb4151ed0ebbbbb90a6b6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ef700a6bd3432fafd249367bcf33c17e6abce288cf71aa7c38d919c6c5d0906"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04cc3cc1067fe5b703838b94bbbafc1de73f352e844fcf4112a26983471b2be0"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd7d0b8aad0c33a47f822efe397fc429a4ed4eeaa95662696faac8cc9839d226"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f90a094a41d5a4aeb4e744d8076fa69b3e41d549401fefd14ae52421a1c2fed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4ece1aa3d4e2594ebe690e7f578d0b53b705cb94dc68ab46049352911cb42b4"
  end

  depends_on "go" => :build

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