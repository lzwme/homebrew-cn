class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.31.0",
      revision: "3d3005dace9f8aa418a8f042eec530ec47df45af"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc0966aed8794dcce8f524cdd39d1a0c73d27b579e2b6410abe451a6390965ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cca4976054a53ecaebf8d2cd27a275fb83d4f57de1e6983ef3c0bb7da8efc62d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc857fcb3338d97ec2bb936b34ffc5ef46a091f166ae04ec7f2dca28a1c1b868"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d864b05d4940b7f2b57a4dd8c67bec60f9b5330c8eb383396cef293cc43153f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca8667f99784e8c0d6ba10dccabacdb8a13b31a689a7969d747c0dd735acae5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6735041d5864b2ab734d666335defba2899445daffddfe31b5ab935ffcc93e37"
  end

  depends_on "go" => :build
  depends_on "helm@3"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{Utils.git_head} -X main.buildDate=#{time.iso8601} -X main.version=#{version}"
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", shell_parameter_format: :cobra)
  end

  test do
    ENV.prepend_path "PATH", Formula["helm@3"].opt_bin

    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end