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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21dd70bba1cc4280357c76956228b1bed5e91943c8aeea4d0b7c50f922a91441"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "547ead02c51508454372b99fde9607cea30ea2f1e67a63fde31159e4c30532a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e75602ffddde8b9480efba6d2f530da32f7d8feb10e25fbe08383c4b79b587cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "50e849378fc6da766418d8ac2c13755ccb2cf0ec30b776f445df04dc5dec3eaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c37f723a027235f7c3efde74c5487a186f674440f574d6a3748cee3c9ba95196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7efee78aeb2defe171ec2bbff6cbed0a18e0e78586e7a1724bf1538a8a2967cd"
  end

  depends_on "go" => :build
  depends_on "helm@3"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{Utils.git_head} -X main.buildDate=#{time.iso8601} -X main.version=#{version}"
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", "completion")
  end

  test do
    ENV.prepend_path "PATH", Formula["helm@3"].opt_bin

    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end