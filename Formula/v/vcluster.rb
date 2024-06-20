class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https:www.vcluster.com"
  url "https:github.comloft-shvcluster.git",
      tag:      "v0.19.6",
      revision: "37892ff5668e1401536f4fd07706839343bca65a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b6925574ce01be4a1122147143895931097fffc34f08c362cbdb08d207ada24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7c3357493925f2050da5b4f5075cb59897ac951b35c1ec0d32f2ffdb3fdc12e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e5e4a0bdff029e39bc813c7c78ecd1b87c5405c6f697c8c2a61844089fbe9c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf7a7b2139e477cd81f036125e38cb500a954fb96485d2da2ff829790fc879f8"
    sha256 cellar: :any_skip_relocation, ventura:        "1db4a5af5f7146ccc1c99f18475650ccf59bdb3db7d89fbafa228e657b7cc1b3"
    sha256 cellar: :any_skip_relocation, monterey:       "892f0b967ca22ae53caa597609e64c2f8ff8ac32fd21d611d43d9ad80cc23dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e1d436afcb0d67ca90777cd616f88000d53ff418770458178af62ec882bfd36"
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