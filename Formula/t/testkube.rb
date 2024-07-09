class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.0.5.tar.gz"
  sha256 "8075963c335359ca11bb151ba638e78c38ee2e9c7c4dc64830ac50c279dc1903"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fb8c70be3096efe16cd4b51f07cae1ac4782cfafc4fe0fcffa85bdd1e2f9239"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51e483e84a7637246c60eb2fd78d6618374126b9efa4ecc48b3953f31c00a9f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8039e53b53b36d96cbfb7f62bec65033dbdc0018682a0013deee7c4adc7f6a33"
    sha256 cellar: :any_skip_relocation, sonoma:         "95584cd912671c463db8da8002842ae00fd9f86feb0855225a10dde69d62a3ac"
    sha256 cellar: :any_skip_relocation, ventura:        "8c0bf63c59649995a56500820c2016afa2bbb2fb2afe19ca4b574c186ebdbf50"
    sha256 cellar: :any_skip_relocation, monterey:       "af26652b0a6800debc683a81428ba40668372588b24a2432cf8a1547a08ebb12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53fd04410344e5640f5e354b61fac8f027c492f9fac4f35d43d459a962ffcecd"
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