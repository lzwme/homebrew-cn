class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.30.0",
      revision: "6ba617b4d88a4211442d0efae4bd5cacce6c085a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acac963da6a5d36521bf54f188492b1c13dc271c9aedc74987bc8e55c1910f7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8fd9ab5075be6e3a237a52cceb75db4bc678bd02c3c13a3b9b92853dee972bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "799430f67311f7b035545d997a77b9e08c5041713d8b21515f729de66db60a06"
    sha256 cellar: :any_skip_relocation, sonoma:        "188be6fcd48ed5430e1ac2c4aeab05190c2b3b7bb5a1d8fb31ea412cf3134d05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd28ba4ff665db580fd48ebdcbeb6cc1165d447e6e5bd1fcf6ff3f22d8debcf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3d1650b92ef194ae6f0a269edda5b9320095a32c18c3b3228479b58d4a7393c"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{Utils.git_head} -X main.buildDate=#{time.iso8601} -X main.version=#{version}"
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end