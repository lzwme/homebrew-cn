class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.129.tar.gz"
  sha256 "4ca308c90d5679423b54777813665a9c6aba6b0d03f9ac6a5983c25ec49cac17"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94030bd5da1836ba228f2eb05a215446d54092cb3a826c4da18053f2cd14e7ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94030bd5da1836ba228f2eb05a215446d54092cb3a826c4da18053f2cd14e7ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94030bd5da1836ba228f2eb05a215446d54092cb3a826c4da18053f2cd14e7ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1b0b9fc6591e87d9d19163a4464b10dd043e226a9aecd64b738f3483f76f20a"
    sha256 cellar: :any_skip_relocation, ventura:       "c1b0b9fc6591e87d9d19163a4464b10dd043e226a9aecd64b738f3483f76f20a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abf180df9841c65402db9b434ddb47f95eddb14abbdcb6c0f2e4c219cdef995d"
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