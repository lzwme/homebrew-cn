class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https:argoproj.io"
  url "https:github.comargoprojargo-workflows.git",
      tag:      "v3.5.9",
      revision: "45b59a6ccf208149321403f6c822a483e4891f79"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20be067af987f2d8fe5aeeffc9d4d45ff3b48aea56bf1c2d45294e3abc9227b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93086f27d73e63f7fa1c12b00c44b1a636d46e34db65b3046d9acb4a0340aac2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3738a5001e3d05b57738fab1aa2d5ec4ae62b62ca74a949ae7304554af117a60"
    sha256 cellar: :any_skip_relocation, sonoma:         "476111cef4963b8714986d6b24908692e63f3e360217e98490e546467b12ad64"
    sha256 cellar: :any_skip_relocation, ventura:        "03c004a16d3d09f90773ce444a8572ce7835c2b88ca608199ca58957ddcc1839"
    sha256 cellar: :any_skip_relocation, monterey:       "63c414ac30dadc6e6a91ed941485e0cc3dfc0fd41e70ea3ae4e7908dac7970e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2709525224c08c61e211b0c265342586be5f76e03adfd9918764c40fe58b4c45"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "distargo"
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