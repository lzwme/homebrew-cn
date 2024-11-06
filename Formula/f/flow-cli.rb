class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.0.10.tar.gz"
  sha256 "59d0b99fadacf36cd127a1a02b005e84bb275a46b42402252c447ceb4732ffe2"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "791b1d29f167bf0a9d3e53cd3eb4e7e94c81776cc03b1c9348faab6f4a64246a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b408321e7dfe49ebfe737654f5265db9240499d8dfe71fedee7650117d17440"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7457bc2c2c7f168d07aca5bb88caeb6016477ce0a6838ffd6be08545d0b7a82"
    sha256 cellar: :any_skip_relocation, sonoma:        "1634564b1ed5a0e86a186b9909ebbe2278665c21742f63158b8761eaec421e0b"
    sha256 cellar: :any_skip_relocation, ventura:       "9b7532074f7f8941cf8df8125c1e058ed1b0cbe6c3ad59c7f925f91a3c383306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "601ac2e50effa069e55c965a73f0cd20d999df815ac938db15207c7488149ec8"
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