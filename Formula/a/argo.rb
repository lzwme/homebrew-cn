class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https:argoproj.io"
  url "https:github.comargoprojargo-workflows.git",
      tag:      "v3.6.3",
      revision: "98eee45f321440b1e0c892a8f85af39e175447ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25d8717d3e8cdeda1d5957ec6ea3651ab70cec9eacb1cf9724d54999a9069154"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00b131f932c0cc3bb74d8f89469334bc978d82b088aa014c57c81007b3c9bb41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bcf53c9a6fb8a66047f6ad9fffd0976c32f254729dd3a7e713fc719a6fb07420"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b69190a5386986a33323cea0fb3796cf8936150760dd25f1c620c174a667683"
    sha256 cellar: :any_skip_relocation, ventura:       "fa51aa6f991f9945e6248578c53a5dce293e90d689e0223e7db74194d3dd5a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20e552cc8e798713062ccd82ebbbf10beb12cd2152c5f62081f03075e185c1f9"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "distargo", "-j1"
    bin.install "distargo"

    generate_completions_from_executable(bin"argo", "completion")
  end

  test do
    assert_match "argo: v#{version}", shell_output("#{bin}argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}argo lint --kubeconfig .kubeconfig .kubeconfig 2>&1", 1)
  end
end