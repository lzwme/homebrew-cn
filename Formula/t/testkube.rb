class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.7.tar.gz"
  sha256 "522599b17a05a2f3d4b929f7be0be1ae90931717a87afe8250d55ff780e1bfea"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e604e9912e576228eb952ea03c08090441369abedf34c2939fd382bf32bccd91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e604e9912e576228eb952ea03c08090441369abedf34c2939fd382bf32bccd91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e604e9912e576228eb952ea03c08090441369abedf34c2939fd382bf32bccd91"
    sha256 cellar: :any_skip_relocation, sonoma:         "674b6e91dcf9db6c310e21e0bf883de51f402bfe266fb20abc48277c1a30c7d8"
    sha256 cellar: :any_skip_relocation, ventura:        "674b6e91dcf9db6c310e21e0bf883de51f402bfe266fb20abc48277c1a30c7d8"
    sha256 cellar: :any_skip_relocation, monterey:       "674b6e91dcf9db6c310e21e0bf883de51f402bfe266fb20abc48277c1a30c7d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f47a9f6e9b77b314925a993941faaae545a4491fc47a6d6230074c29b823a4a6"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin"kubectl-testkube", ldflags:),
      "cmdkubectl-testkubemain.go"

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