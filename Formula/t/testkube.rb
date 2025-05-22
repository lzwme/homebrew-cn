class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.153.tar.gz"
  sha256 "66dbc4b8d273f42a6bbbbd211fa9672c767b12e5debeedcc0e1167f5e2721b86"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "140571e5a113786f9ec9cbd45af8e561104a32cf14bd985cdb7f2e690e325f1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "140571e5a113786f9ec9cbd45af8e561104a32cf14bd985cdb7f2e690e325f1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "140571e5a113786f9ec9cbd45af8e561104a32cf14bd985cdb7f2e690e325f1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b68737a49272a1fe506fe004e0f48b3ecf4bb7627d3d0805b538ed742542b2bf"
    sha256 cellar: :any_skip_relocation, ventura:       "b68737a49272a1fe506fe004e0f48b3ecf4bb7627d3d0805b538ed742542b2bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f20380270b8e49353306773bc5a402076b9e45c1758705734320ab5cabbbd6e8"
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