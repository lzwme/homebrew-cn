class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.107.tar.gz"
  sha256 "67df5b709aae0909163f6d5dfafc13ff97315adde418ea7b7b22bca5e253dbcf"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7000d9054953a37227f74d2f90fd2c817a0800356179f3fb34d1b08c3212a71f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7000d9054953a37227f74d2f90fd2c817a0800356179f3fb34d1b08c3212a71f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7000d9054953a37227f74d2f90fd2c817a0800356179f3fb34d1b08c3212a71f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c87b3c99b9e7e84794061a5b5f138b599616cb156b48019a51a1be9b0788257"
    sha256 cellar: :any_skip_relocation, ventura:       "7c87b3c99b9e7e84794061a5b5f138b599616cb156b48019a51a1be9b0788257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e94717b2fc61da33945e8e18c65a09d792ac3ff1647f4a2a7ff97dc354f856d6"
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