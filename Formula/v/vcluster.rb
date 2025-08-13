class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.27.0",
      revision: "d23f473e89c0caff7b103758e03886dc99dad1f8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9dd30e35b9adc5459af8189d4036c756d9a4666bab737e4c8ac11f7259e540f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fd6af4b753cf2c9f2c1e1144fbff43178fa42fa4c4c900d231f78336d72e1b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e42ec560af42104e1f4180e7946d0bf9e16ac3933dacca7160c6fef626ac814"
    sha256 cellar: :any_skip_relocation, sonoma:        "f06a6f65a13515d35940253d2fa82c5d5304dd911a824931788d371229b851d5"
    sha256 cellar: :any_skip_relocation, ventura:       "eeab2a8900f6b29202fd9d5cc9bb21401145865c2f536fc595f7f4dfe30a03f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26cd752cce82651b736dd6a4869de4dc3237d9f13b6d9757252e70117c88dc30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dd01ef151c2e137c714fae8fc23844e1afa20237ff744ac565ba682360e9aad"
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