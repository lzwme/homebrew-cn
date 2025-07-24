class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.7.0",
      revision: "d1d689b367c4c8a5a8a095ae60b5d7043f99eda9"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ff0d2aac11702eaf47242206eda1db7fc731c33fa7e779cdd659b299ba1fd43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f4a9a5617815b5ad377f98b6624ff068309256faa94f2051bb024de5714001e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c332587f05141be0d6b3c3d11499a0a3c989aa0ca178609334d94a857fd9c5dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3954d581807ac0dafda64c9a240ad204602f3928b94ece030d771a62db50dbf"
    sha256 cellar: :any_skip_relocation, ventura:       "cb6c4072eb4e70f71c5dc22b281370795d4e800cb2a0ae93c6a994aabf46e6b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76bf65f34d3c0b6dddaf598bfd6620d450c54a3cee9baff166362ffaca947147"
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