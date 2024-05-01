class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.21.tar.gz"
  sha256 "58acb6e6918a39751754dfc077f0a28a120b6c70f97bd847b950fe340d099844"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97b0b6454270f7de7e43bf5bd4b1a28ea7e22b18025215f4df5365e991cf2aa5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "805968d098c37050069f81ac1a0190fee439b22c8786c4c2ebfdc39329115b67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07d8ce9003f4fce8a8df9fce3461a87d85ae729c47bb70b25fb9589392a031d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1cda88f86f3c631e3226f1c181598cadc8afe7c2a0ff52e5e1c87750151616e"
    sha256 cellar: :any_skip_relocation, ventura:        "21beba5d71c70ba2de1ba6c7414b1c37bf4cf7e7d8c8a50a1ac76b4af37a6b79"
    sha256 cellar: :any_skip_relocation, monterey:       "1b1c86f562f16808f48ee37c68e840c1cbddd3765d13e77be4c1b0c675f8dae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd934389c87355b6adab7e41fc50c6d64e05b964ef0ee9ea9c2a4587c8406ff5"
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