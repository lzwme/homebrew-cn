class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https:argoproj.io"
  url "https:github.comargoprojargo-workflows.git",
      tag:      "v3.6.6",
      revision: "0c14fbb55566cc17c66eba78bad2b559d9a20e0d"
  license "Apache-2.0"
  head "https:github.comargoprojargo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d07977e504bd69f99f8c2a03690c81791296b051e551891b7b2088ff3feb1015"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0f4211b0dbf59d34f8bc9a5c95444dffb3f7fae0b89161b77c360b33d405310"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b675d3d5406b91e9682d119fe7d902e67a1ae47159cfb9bc8e524c49e7bab21"
    sha256 cellar: :any_skip_relocation, sonoma:        "55f929e9f10d207da95509f85cd8ed6c94879c7a1db60cbe05ffd2d83f3f170d"
    sha256 cellar: :any_skip_relocation, ventura:       "09a1feea2b720eb5ee9001664ae3dca37b2c0060da4dcf619cd685b33466f71c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1535d7a51a1533390cb24caccc7666f0442c2ff3a31fc1525359a11b39d956e"
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