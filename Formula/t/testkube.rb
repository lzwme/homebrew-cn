class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.101.tar.gz"
  sha256 "ed1b94d9988051a6cc84e2e332ed8d5463b41f7e80708ba92ebde8d92820ee5d"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1447e813c10cb4845d1dbf6c6810d1129dbc72042fbe90cec77c14dc7dd50ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1447e813c10cb4845d1dbf6c6810d1129dbc72042fbe90cec77c14dc7dd50ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1447e813c10cb4845d1dbf6c6810d1129dbc72042fbe90cec77c14dc7dd50ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "d689ea0a2dbba66820705e1356f3bf7ccb90b27bab21e053cf00e54fc9129517"
    sha256 cellar: :any_skip_relocation, ventura:       "d689ea0a2dbba66820705e1356f3bf7ccb90b27bab21e053cf00e54fc9129517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b4c374037c5649062df55b52e839362170d2cbfce5e43747d4915f3ba6c2e0d"
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