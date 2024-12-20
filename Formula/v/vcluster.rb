class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https:www.vcluster.com"
  url "https:github.comloft-shvcluster.git",
      tag:      "v0.22.0",
      revision: "8ff86da29c5628d338613c5d6fafba547c8c9a73"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ac68de212ccc77ef149f434d18b6ff5945791461df6144474916d497e5261d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e54cd95463af54707cfa1bf1a803ca7c81579a11ca377243edfa3a77ea12f02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d27cd4750f18e31d95f53743674668a8bf82213119de2e0c06dda12538bf6358"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9cb856a56e21d4ce5cd619dc682142b93c7b5066736a4b67d07fb3addb48dbc"
    sha256 cellar: :any_skip_relocation, ventura:       "60a068fa637ea8076e4277a37b004f1ce0b515946e08883f60a106788fb4f255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "097c1c39dd63fe4e409eaaa993d68911d4b634d8c4529335e2f18511765d3498"
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