class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https:argoproj.io"
  url "https:github.comargoprojargo-workflows.git",
      tag:      "v3.6.0",
      revision: "b26ed4aa4dee395844531efa4a76a022183bec22"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e91f7cee8189af64bc956f0bb72279c0faf55c84e8945db6b6061569cd5024b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5567cf7f7fe5259db124df9417c714f7432b21385f6a53996c4d81bc45baaaca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ca0b4a7443ff7fbfb275ad1a0ac71272593ead6d55497ef10305fec0b757b03"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb7bfa175856a3c60540c59f15c3c22b8725440831cfd4564e4fa30bf3f8e35a"
    sha256 cellar: :any_skip_relocation, ventura:       "dc54b4e180faedd8ba5535a19ea8299dffd1cb034d6c194570a2a48c6a4d786a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8afe5fb8c3138edd03b7f87539aa557565d7f4d13bf646806339c9fcab898fb"
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