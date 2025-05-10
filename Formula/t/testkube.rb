class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.150.tar.gz"
  sha256 "7f5c06c223f8e888ed2c5f341cf03de7f3a29271fdf478173351e7647a471d8f"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70645be2f903622d5d0acd6351da7cd8146f83a2bc3eddecef71c872b7988a7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70645be2f903622d5d0acd6351da7cd8146f83a2bc3eddecef71c872b7988a7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70645be2f903622d5d0acd6351da7cd8146f83a2bc3eddecef71c872b7988a7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac3224360690527478e2858782191b6d9b36c06bee75b87b746a420478c8f28f"
    sha256 cellar: :any_skip_relocation, ventura:       "ac3224360690527478e2858782191b6d9b36c06bee75b87b746a420478c8f28f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af64df28091c269f77a7b6e7c53afcd930925fdfaf2fc3d6d75ac92e2100af81"
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