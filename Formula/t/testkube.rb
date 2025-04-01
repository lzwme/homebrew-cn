class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.131.tar.gz"
  sha256 "39c1e025f4303e4db2b6a6462bd2da133afe20c96dbb5597abbcb28ff3949d45"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f0bafc402be5c24e6f604ee9c0fead43df9ae5b2ac2662dfd3ff25e3ce64a45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f0bafc402be5c24e6f604ee9c0fead43df9ae5b2ac2662dfd3ff25e3ce64a45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f0bafc402be5c24e6f604ee9c0fead43df9ae5b2ac2662dfd3ff25e3ce64a45"
    sha256 cellar: :any_skip_relocation, sonoma:        "d704f5c932ae57dda59d5c5987a2b364bb2cbabfa418f13b364bd9a2fa5e2462"
    sha256 cellar: :any_skip_relocation, ventura:       "d704f5c932ae57dda59d5c5987a2b364bb2cbabfa418f13b364bd9a2fa5e2462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd3b748e82d85d8e2ee8f5589d6ae44d5f05f8f51da2df47b6574a25bd7dc2c0"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin"kubectl-testkube"), ".cmdkubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end