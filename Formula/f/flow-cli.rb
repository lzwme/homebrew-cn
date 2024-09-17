class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.0.3.tar.gz"
  sha256 "cfa997eb2abc256ac8933e1c176fe8bc727ea6622257646cd1bc422f24be8064"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5fc3e4a6335343341d54351635ffdf4c2e7d5eca37815060d2265f72d6f18e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fadb3fa6568dd912a6bd2452e0a733868e40644641616cea1b70d32beaa91a0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aeb85e387949b58e9454e81ae84f76cc7b148d04a0fb22a88843bc367557bdf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a8e26302841e59c691e002b249894df25290188130fc79088cb887275fea44e"
    sha256 cellar: :any_skip_relocation, ventura:       "db8b3e8fe12637fac26262c84ea08f5c7974578079f21d43663f3e0a8078886f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2de3c347b9b8ea143c195ea850d882ba486e137834c5334c925f062676257a2"
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