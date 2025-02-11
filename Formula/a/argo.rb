class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https:argoproj.io"
  url "https:github.comargoprojargo-workflows.git",
      tag:      "v3.6.4",
      revision: "77552d852da5c53a1d8c9918b3474d8bff06260a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab7fe9b45c06889bf221836765c1a3bd86740119c6ceda80ef82772b655538fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebfd9f14bae5df2302788489ac9eafab55bdf3a13b444766bb28f8ad4c67ff31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4883893291228c0aeec93d1a01a00eca95b00e1ad3204057a665c57d9dc86e27"
    sha256 cellar: :any_skip_relocation, sonoma:        "afc48a10ea19ce2e06fa0d76e5cb882eda093dd95e876f38dfd5bedec25ed649"
    sha256 cellar: :any_skip_relocation, ventura:       "b462ecca8c06143029c145ad57f289f6eab64a42696903026f1c13cd2d7e3831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da5647b2b2421d9af15f75841b473b039046dea63dee64d996f05e4bd2fd55ef"
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