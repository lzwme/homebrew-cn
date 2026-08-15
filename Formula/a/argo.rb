class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v4.1.1",
      revision: "eaefb4518483312d69ace640479b565ccd688fdc"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8ac7c042d8ab61f7aec5ac26c6054c80e5861e9da67b2078f5cf51fbdacfc6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce35b306cf9ac10be132faaf8ccb5f732c8d09b5f9c8ad098d1eca98e006279d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17013a09f8c4dc9fd523ff2f69c3024393f15ca6ab918c32334ed821c5ade6a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "964bd429b405ad4db2ae8894a3a25ee594c13ef3a031210056a2f78035dc614b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84ab09aa5811b392b110f02795b33517002db9b2c40b2fc3889ac140b3c9d289"
    sha256 cellar: :any,                 x86_64_linux:  "055572b55d8d3e366a1a64bd775e70c0997af5cd503e761cfc134b65b95aa718"
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