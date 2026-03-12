class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v4.0.2",
      revision: "32afec3c401c0920517bf1e890fa7dba6170cdf2"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "556ef5b6c75d7296c95ccab88292d3d4292e175eea59c92d44e029f05269a5d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4433883ba7cd54c553e58996e066a159ba4a61a1f2d2018da9f1fcfcbc79b591"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdbfd7fea37824d72d19f5fb49e3c118bec38f3280f1d9dc5dad6927af605b31"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e8d06b43a4c9a043f054c38ed6c5d37d2146afd37ff4eaddee59c7e5146af6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "662c2f40428b5332ba94a724976542800a98bb5eb81da763017c38953b36120e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a418f4a35b3d87c96aaab049e3db27b8ae8a79991dd010af28f276ba9bbe167c"
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