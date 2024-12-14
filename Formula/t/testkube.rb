class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.75.tar.gz"
  sha256 "d4a3ba5ed446f14d9ffbfff6c0fae56e3ccd9d7eca9a3d8cd14af02baa641e90"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75467193c60eb24a0d143ac6f97a1c0f90cc8a94b060da4c7cb12514c68be2e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75467193c60eb24a0d143ac6f97a1c0f90cc8a94b060da4c7cb12514c68be2e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75467193c60eb24a0d143ac6f97a1c0f90cc8a94b060da4c7cb12514c68be2e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7def57f390fbc2ad2dabe713052bac156842b91ed21eab91cfa51dd8dd42850"
    sha256 cellar: :any_skip_relocation, ventura:       "c7def57f390fbc2ad2dabe713052bac156842b91ed21eab91cfa51dd8dd42850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d5456e927fe05e103c78aff32ebd398cd9fa0ee609891e57633bbb6cf9abf97"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin"kubectl-testkube"), ".cmdkubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin"kubectl-testkube", "completion", base_name: "kubectl-testkube")
  end

  test do
    output = shell_output("#{bin}kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end