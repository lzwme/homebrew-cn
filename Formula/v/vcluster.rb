class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.34.2",
      revision: "de49d3bdf9faf67b13f810bb77e7d3546f058b91"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce5c1513476611a1d31a3a6ceef13e9ab92009293edc226a113d46c329709214"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "295ff5a2c9e14790d0f23764c46c788e486401341c000294a43b4c66ba09c9a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "936db295982dc28e2aba962320821a640cd360dd6128a21e03453d1ef8f721ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "23efce42a354505c224e1b542f114d5f86e589deda071db05792d9358d5774bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31963b173f347eaf167f77a6ca7657d318e7c372d7db1854e557a59ba8ae6183"
    sha256 cellar: :any,                 x86_64_linux:  "21f1e722b7e89231e32a990dcdced19e2ba9eafcf90743f0db71ea31e2f60e21"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{Utils.git_head} -X main.buildDate=#{time.iso8601} -X main.version=#{version}"
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end