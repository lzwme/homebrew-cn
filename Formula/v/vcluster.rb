class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https:www.vcluster.com"
  url "https:github.comloft-shvcluster.git",
      tag:      "v0.20.2",
      revision: "b375fe1c30b8c95223229a6925232dd5e2c28f6f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8e9cbaadb9e4d2191cdd8d9476de49529cd0cdeb26b15bf03912f50d0c1ee98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d08b18f7c99d75248944c6d475100e831aaa589c5c9dc50c26adf12f7b4f6bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d8cc0e22fa1322bce444c55aff00a6ecb15f2f18b79a8036f3236c5d1133e1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "91a75a05d769f3958b6e2434c66a72dd8e8fc758f0d9d7cafaa9bf69caab777f"
    sha256 cellar: :any_skip_relocation, ventura:       "c5bf3f4e86a595e5173651c56c2d841669b23368b8c8ace770630a48f19f6e0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8f612e9390e77137e1938590083e0c2573356547123d02be06a1b5bc0e0f39f"
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