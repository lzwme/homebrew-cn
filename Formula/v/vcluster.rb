class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https:www.vcluster.com"
  url "https:github.comloft-shvcluster.git",
      tag:      "v0.22.2",
      revision: "360c19759bee6f0e6558c3ae674bf05835c24a51"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de0c8765b6e6295817acf5cd96c956debd5b48adacd842f8102c3cc342af8229"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c812987faced73733fef9ba5b2cca055465ce2059c816056f8ed3c0dc9a5982b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a601db2bbb2e8ec4db7028f7a482872cd7a5f99541c44d2c4a457dffee24986"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c4236b4f6e02643ddcbad09ae77e18dbf21c65a36eb34fd64d23ea37714456e"
    sha256 cellar: :any_skip_relocation, ventura:       "5c2b91a5c9c198503d66bb5029cf947ec3e9a1c51dcff603b8e08aa02353d800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1fe297a7e52b6c18cada21048b1ba5fb6420f4308ddc917377d30de1e54b431"
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