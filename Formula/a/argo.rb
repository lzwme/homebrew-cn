class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.7.3",
      revision: "bded09fe4abd37cb98d7fc81b4c14a6f5034e9ab"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2e2ee58797a7c5bd7263737aab60392f25495707a0fcce259ce292a5dcc6207"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a390d3753227f11fed5e25a2ce184533c60f70f7d173cfeea7802d76b75cd4cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0d6344d55adb0da779bafc6c7fe987b00c87bb300be2f675da157e463131558"
    sha256 cellar: :any_skip_relocation, sonoma:        "a20107eaa6d1da6afbd14c1108c8402119a14c12894cb36d5650649d3e3fe55e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "675e5cc98b550e08b3b52b004ab5884edcbaac59fd1d526c6d3f36a5168d0f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "797a27cac49e6c0bf0bc925163f3ae1fd840428e4fb152b9889f62768efd4e5d"
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