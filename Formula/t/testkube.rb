class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.117.tar.gz"
  sha256 "ba349a5cd655138b9e02c6f16ed8ee548985cbab2f2750d9b74d0189aed9656e"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ef4627470d8d48ef537742795e6ae78d6a6cf2b9be0c37c2975ac2be83dbd89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ef4627470d8d48ef537742795e6ae78d6a6cf2b9be0c37c2975ac2be83dbd89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ef4627470d8d48ef537742795e6ae78d6a6cf2b9be0c37c2975ac2be83dbd89"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b7f2a5278e7994626fd5a499c66b8089bac6b2e1cce8fdc92970be0abedfea2"
    sha256 cellar: :any_skip_relocation, ventura:       "0b7f2a5278e7994626fd5a499c66b8089bac6b2e1cce8fdc92970be0abedfea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf1e986262cc9562bb4bda785a4528ec4d38039459e4dcade64b8d11134c7d3a"
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