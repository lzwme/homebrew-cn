class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.2.9.tar.gz"
  sha256 "05fcb926f7c79fde0944874bf070e2d4dbee6c45d7e882452098afd9d9b01428"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d95a7b1aa42a67fcbf53848873dc9ef539ef27b910a410ba2a8d4ba260b11be2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8112736db33dfc89087f99ab9ad81c9064549671f0275c937449d75472a549e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42d009c4d8050fb43cf837e9b44d42528cc8307072d8c2561ad9779c30da77c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9bf527ab78c2498ffa0a0bbfec055cf32380683e78d44bf0bfc031f5b84da99"
    sha256 cellar: :any_skip_relocation, ventura:       "4a755e0fcb877ae23dba08f3674aab78f987c9d2983b0d0f342ecd9562e2b4ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b35a0a8a615bf9f02dae54e4659a300672b92fff509556ea14180656c6db6c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acd84f4905e89265aafc8b09878202459cc4d93a3bae198a4eb7d61df5f748fc"
  end

  depends_on "go@1.23" => :build # crashes with go 1.24, see https:github.comonflowflow-cliissues1902

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmdflowflow", "VERSION=v#{version}"
    bin.install "cmdflowflow"

    generate_completions_from_executable(bin"flow", "completion")
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