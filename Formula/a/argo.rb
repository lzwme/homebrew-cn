class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https:argoproj.io"
  url "https:github.comargoprojargo-workflows.git",
      tag:      "v3.6.2",
      revision: "741ab0ef7b6432925e49882cb4294adccf5912ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "714af182791ea6284edfc8ec7182ec1659ab395aaffc6454d8df3bf0b712620c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b130184f05654f6de68c2857f189da277620fe10dfa69f96480179e4fd53581"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "218f8888aa055d0bbdacc1f045139c11d17bbf718c7b35d6be004a959278e843"
    sha256 cellar: :any_skip_relocation, sonoma:        "05162c80543fde9676d53f73f080af7247d5f8c222dd65ac6a91a05a213d5213"
    sha256 cellar: :any_skip_relocation, ventura:       "9d4a5848b916825aabec8427d80348418f0794981ecd8f6d2b1418137f896590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18f5d2c499eada03498c27b3f7171dadc3c47de8e95212e67e1291a3ff53288b"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "distargo", "-j1"
    bin.install "distargo"

    generate_completions_from_executable(bin"argo", "completion", shells: [:bash, :zsh])
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