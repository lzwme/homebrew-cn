class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.9.tar.gz"
  sha256 "a818ee5e86ecc20aa6df557803b6a21dffe926ca587353d67c55d7dc58941d10"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30ff941e44a6ef33c4399528cabf9757b5e411bff60ca4258524e43a357a6576"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4955817e1bd291f9c9e0aa6a7ec9ac262850a8fe1498b2d400d7cc13d63368d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46656f1a67af965e4b28a870924ed1accf6d7b8dcca3acfdb2c8b52b998e99e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "877d23d20712e49d7d38234795743cae87f7d24c5fd7a150ce98ab4588c6275a"
    sha256 cellar: :any_skip_relocation, ventura:        "405860a62508983da79db7e5bd61ed04ff2108b0cbc755c7d40db62dd6aba9f4"
    sha256 cellar: :any_skip_relocation, monterey:       "461833fd7c284b31008e09528993070bcbfadbf575ca8ae869703ddd4550f32a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "844049ea41355fb33382b762cec1753143bccd00c9a08b75a57e7186d33aee19"
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