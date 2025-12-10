class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.7.6",
      revision: "9572e7b8243834b951385584c2a344378accb76d"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0da35b79fd3e39654b1de4d3827890a58bf7e24e447439916bd58146ef3e409"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0be2f08e3173f5d333df2cd5c1ad4c1176750608142e04ffd73bddf8d949ba8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41f87097d5a074ceb707e44410be3aa05b6ce37dc35e409ef165f70ba585c5ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "19216f5a0068c54e2ec1f7c7f6f8163fd223fcef5b99c856e3e21ad39d172a26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "253d8cf3d167f237e169d909fe9cee82f4828d99b0e5052417d3fe0258179ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ef841d00520dcfd80e347d8d105b73dc938ec683fd34d67d5a303c51e2ef64e"
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