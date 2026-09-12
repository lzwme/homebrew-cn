class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v4.1.3",
      revision: "5fdad0fe6f6d740c55d8289f26c912ab711ca407"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ddf46f4506d080da7e902012b69d3537d5d3774279ae386bad229456e2583710"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "feadd5c3d0511034f15f53f5331b57b1a0b83e2dad3454c62a19aa4588a0a3b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "725c2489dcc5dbd4b739524c04c03c817fa5032b5f5106a58aaf4892b3c3db2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d3bc05941a810c0d27f6196dc5e5feda9c2c95ded12f443dabd08677ccec0793"
    sha256 cellar: :any,                 x86_64_linux:      "0c2433a112bfb049712d98dbc9a94d19ed2fcddcec028b8de4bb3d5b53bc9f6a"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo", "-j1"
    bin.install "dist/argo"

    generate_completions_from_executable(bin/"argo", "completion")
  end

  test do
    assert_match "argo: v#{version}", shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end