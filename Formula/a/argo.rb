class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v4.0.0",
      revision: "a8bff4a72130bc1a13d95c6f73ff3fafec880287"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cc347de0d3f5fc10941e0778de06552ca6ed9e4550fb10b6520b6bdff22f17a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cd07ea630660dbe7e415d87bbb19ea17cc2de9181fe7a869ebe09ea316a1b90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7314e0733ff8021dd0f87943cd541b69b0477c984edde825006cf8825c378824"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7ebeb3274b57729f0470a63cf36d75f826c459701f85b3878eda9ee70597c97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2eafa541f6d67567de1ca0beaf1ba8a1d674bae0062e4643bf0593e02f20a59e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a691df20d868349a3b4e10ce41a7be8009eece8437cb6c44d534c9287fcc4ca"
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