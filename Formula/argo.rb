class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.4.6",
      revision: "988706dd131cf98808f09fb7cc03780e2af94c73"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6451f6e9a4072f4f46f7a2b90642cde57e086373a13445e0c5cec017ab00b428"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d897c881d1d7b9c92c94f813d5212dc8b7014db9f44665772e56aa799abdf1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbfeb26e2396d043ff64e612f378ffb72825d802a4cbd99e9bc066f6d0068a34"
    sha256 cellar: :any_skip_relocation, ventura:        "1a17fca856aa91c372b74f89dabcd0f0439f43d3338ca9e3d07e0c90a39466d4"
    sha256 cellar: :any_skip_relocation, monterey:       "fc54d959b5961b981d9a373e9d96a45c097097be7544197ac5e49a03874fcd1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3022d380bcada0b0a3a4fe696f3668203a23873a314294288fdd9e87e68ed007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "281d2025a8301c5e5daf54d1c4542df0f1dd4151726c7344578629d2407df1c7"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo"
    bin.install "dist/argo"

    generate_completions_from_executable(bin/"argo", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "argo:",
      shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end