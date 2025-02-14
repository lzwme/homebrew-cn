class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.204.0",
      revision: "b073ca55e17aebc638cb55f8cc08f0ac87b1fc30"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b50cd6409cde773f2d1f73febcabf019755156ba594cd2cdc95a078db23a5b82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8883a2efa5622aeb769fe7b17e5531743fdea3b53c674ba73b12d19ed77c0e30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef66bb5bf4e9fbc79279565f7ebe5523ef18151efc5bb6d21a832a38f2d21052"
    sha256 cellar: :any_skip_relocation, sonoma:        "218b185d9aa02df807f94b59c2e6039e095547129aa0422645db3fcc29a54ecb"
    sha256 cellar: :any_skip_relocation, ventura:       "3102b3eca3759b93ab6f20e4404d8d3e14ecd8d6a130716ce469d33b398c9495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d1a3765d801485ee9fa01680050e69eba8d091720cc7dafbfe6352012cce9b6"
  end

  depends_on "go" => :build

  def install
    system "make", "binary"
    bin.install "eksctl"

    generate_completions_from_executable(bin"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}eksctl create nodegroup 2>&1", 1)
  end
end