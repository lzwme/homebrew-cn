class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.35.0",
      revision: "5b46b288665a520c2072a77adbe2f94c2e7e4b4e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a4dd31842adc8cc045137b94cd36220ae2a13016167fb365b2121758857f2f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c61b153da5b76ba1200d153f3c6915338e0d29629d6852c158384324f822e64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "060b8102a88fb61b7a3c76a50f78a3e32ef4a4cead06c459205225263f5a9ea2"
    sha256 cellar: :any_skip_relocation, sonoma:        "11effa214e0af661378e84ed4734e0ac9479a9937509197dc52780aa20fe9622"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85819901a85d05229d744f05662ba69a92c0e00efee14b09363e244263ffe8b0"
    sha256 cellar: :any,                 x86_64_linux:  "bc4350efdef3dadf92dddb6f15d8ceabfbec2bb100872d2534a7ffec363b7b4f"
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