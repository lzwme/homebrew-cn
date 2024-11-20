class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https:www.vcluster.com"
  url "https:github.comloft-shvcluster.git",
      tag:      "v0.21.1",
      revision: "f29818a729e0189e781e65d576f4ec833e6ccf6e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19b2c531ca9eea747c3d917a377f856b8dbb1684746571b1cac7dc9c48110632"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92df2fc7b58555240025a46e2204dcac083ac83d44ea8378a028c7d06760f979"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b59fd7997542682c212c2b6a482ebfc68919bd8597587abd1822698fb8838a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "562debef79bced454a730771de5a86e11a6794dc5851f3d4e28518acc8d0d8ab"
    sha256 cellar: :any_skip_relocation, ventura:       "fd6da8cc2d5bcc2a9abad07f87c98325399a58f82b3f476bcad939823e445349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "132de3c092e94de19825fd6ae0fb8cd30569859073a3a56def9d6f46ca6ca021"
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