class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https:www.vcluster.com"
  url "https:github.comloft-shvcluster.git",
      tag:      "v0.20.4",
      revision: "7808698af19bc2b08d86f535c57188d8d3483719"
  license "Apache-2.0"
  head "https:github.comloft-shvcluster.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbb8a1ab15f5cd4656ca82565dec33fb231e57b49c191947028fb6469b9d2fd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bb4660e9e4fb4b7fc20dd90ed65159f4c1605ccff947568f3a839d750257ba4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed0c07f6a6991529962f422a86eb63735216545d2ac8494003cabd864532e120"
    sha256 cellar: :any_skip_relocation, sonoma:        "56fde4cf32d287b1f154f9e0cf4f7998b5bb962834909dae311146f8bbf8f35d"
    sha256 cellar: :any_skip_relocation, ventura:       "a28dc03dd03e8746c551d4c79867b936b8bb3905a85469a47e11cc0b55a0d280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97336e8bd00eb1bc5f9f07fbad2ab81268933bc68b4cbdf8d6de3e40490d3c92"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.buildDate=#{time.iso8601}
      -X main.version=#{version}
    ]
    system "go", "generate", "...."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), ".cmdvclusterctlmain.go"
    generate_completions_from_executable(bin"vcluster", "completion")
  end

  test do
    help_output = "vcluster root command"
    assert_match help_output, shell_output("#{bin}vcluster --help")

    create_output = "there is an error loading your current kube config " \
                    "(invalid configuration: no configuration has been provided, " \
                    "try setting KUBERNETES_MASTER environment variable), " \
                    "please make sure you have access to a kubernetes cluster and the command " \
                    "`kubectl get namespaces` is working"
    assert_match create_output, shell_output("#{bin}vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
  end
end