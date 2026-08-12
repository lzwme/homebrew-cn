class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v4.1.0",
      revision: "e5ed20d5cb54d4708d5aeb29148b3e49922f795c"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7427b1785dee7afcfe98e8651878fffeb54611e1ba73711f878236050b14285f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e748f124b0c47e20ef5f0f9e064c45910fdc111e77618374d3d9c81cf830d31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f6491375541c61f31c3fe6e5630a1cfd95af5bf86b576900682a147ef4d1ede"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0b6961f27f3df66571f727b1370ec76f7b3e8874355b13c713dfeae66d40700"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c8ee68fb6739c461c87091ea699af4845abe3e621885aed41a7e40427b392b4"
    sha256 cellar: :any,                 x86_64_linux:  "29f0c2a989acd651b1a35d01595a44efa5afa669b8dc25b78150830542c5959d"
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