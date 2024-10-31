class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https:argoproj.io"
  url "https:github.comargoprojargo-workflows.git",
      tag:      "v3.5.12",
      revision: "8fe8de2e16ec39a5477df17586a3d212ec63a4bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14cf8c0aa5509140bf337acbdcaf04a2369dd89ff9f820e86cf36abfb18c467a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fb431233f0d858b2f62e67d6c67285808d25fcae7002467d38968740265aa30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2cfcbe3ccb3edbf04e06a448d292e9439a66891c20703354a00c0f1a2ebd8ff6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c6a7c4eb22147511e02ffb080193ad3e8d2cce451fd3e3c0b6700b8e69a9670"
    sha256 cellar: :any_skip_relocation, ventura:       "0436ee08f82cfe503aea8e1c7e2e4a8afaef32651ac0b853e97b458b31eaf1ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eb83572c88fe05671446888b4374dffd40574e150a28c712dc254ef7b3c98b5"
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