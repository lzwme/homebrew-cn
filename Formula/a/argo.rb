class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.7.1",
      revision: "a7cd8a49bf184ad864275acc1bf3189ebefa118c"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1074f355eba07723dc33051ae039989fc132e07ec24e804a5771ca9e9f6531a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c5af720bc9768623346e455815e99244137ce64c4d3a7eda9d3d181a5849551"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54d3817609142795c2383a8fedf70c1bba3f39c97bc4469fac6f3e955e29eb6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "00ff7de1d93a8198ba9b26582c26b30e7f2b1eaa4b08c7f3359e8d67f23de5ac"
    sha256 cellar: :any_skip_relocation, ventura:       "d78963f30de4712f99caadba2cd884e758dd18bc42da551028053b4596a1b639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cb8e7f9539004d1f1b1f378fdab6a29e20059cebb88ffb9f2ae5faa5b671b11"
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