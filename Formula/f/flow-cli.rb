class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.2.1.tar.gz"
  sha256 "85c421273a36a33e11e9310326ffa04e411b691232355cc6562700dc4eef1563"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09339d8414e13ced2d98cf2120678d252ce54934be91c40f0567d7d82cebdd12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb72f06538bb83c913b6419587efef619a276b5eb6b96fdde568041a2a50537e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddc7b5218b8c501acea80c4ac0c9aff35061ac9198c067c4010e3ad46d950618"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e3fc3a8af533a44b047bf4989f8cab0706d5a704d410acd12ed870adc1eaaf8"
    sha256 cellar: :any_skip_relocation, ventura:       "37ba14e68cd4a32d4167c4be9a0dd62fe59e62e1d95daf4d904bc17e8a4841c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3c32db90b61d844c423fa6c801e2b9bf2dd8734c0e5cd84b9bc7e85b34b3eb7"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmdflowflow", "VERSION=v#{version}"
    bin.install "cmdflowflow"

    generate_completions_from_executable(bin"flow", "completion", base_name: "flow")
  end

  test do
    (testpath"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin"flow", "cadence", "hello.cdc"
  end
end