class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://ghfast.top/https://github.com/loft-sh/vcluster/archive/refs/tags/v0.37.2.tar.gz"
  sha256 "2e72497fa08a583d4d1f325427e2406c34e2876d98e0f4b70f0867dc07c62424"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb501d1e3bab65b21dff4cd3cc7bce1d3d29c005043321a96a02d166ab2b47f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "684d25c79786fa555e65213e9049c4831a9adf0db9a7f34c25738e036ff86431"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f7f478185bd9496e593f37015fb059968db196b9d1f8617e25bf8e43045787ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ddedfd30dcff74865e6480f6b18d4eafd6e7d49fcfb21f96024b5bab139b2102"
    sha256 cellar: :any,                 x86_64_linux:      "c3842adade9cb6019c21e96141ca0fb4fa65a30576535fa86edb5c22faff3cb8"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end