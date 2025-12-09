class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.7.5",
      revision: "5052559257e3a3ab965d8c6408af0d2fa3b5e822"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2661e6452c6b3a727f14031e4b1f2d407992a808ef92c53d5929aa2610789ab0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d832ca78cb2413096724fb649bf50aacfa5e88db580eca7b44ca3305b2d43dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73bad9cae694d13cacfdc99d0984e2843687dc471c5a5da231bf2ee5599eed90"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3045e199c21ee6cee92d08d557e93d9d857b2e340fe9b4a282e4aff09ecfc5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cac2763e98b7eb914030fe5abf89a0631d85ea6ec34ad72a3606e17139957441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e44d9bb771993077eda5179d99f69d05890ef0d44b02796fb4afa297141c9477"
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