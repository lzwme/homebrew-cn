class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.84.tar.gz"
  sha256 "5693e75707f093a8e152b71c5655030cc7a8c953ae675d6c34c8cd4154beffc3"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5dc52da90ae8a842a40f26b16d85d9e08b5016b75141ca0d75d323d8df9500b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5dc52da90ae8a842a40f26b16d85d9e08b5016b75141ca0d75d323d8df9500b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5dc52da90ae8a842a40f26b16d85d9e08b5016b75141ca0d75d323d8df9500b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7e6eb1a4300ae52c5f0856b010310a9b40e374df92a2b67149b73e1d46183eb"
    sha256 cellar: :any_skip_relocation, ventura:       "b7e6eb1a4300ae52c5f0856b010310a9b40e374df92a2b67149b73e1d46183eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa6c7615da6fefdfd67c38937b369d55b47aeb08e626ac0d15ed3e01494a062b"
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