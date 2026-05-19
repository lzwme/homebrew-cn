class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.34.0",
      revision: "bb9e88b0a9e45c68d744eebe6bde5c4664cdb676"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e7c4b7acc55784fa6e33eaddf3738c9ea30716e52d2ca81964fb8e6e818ccbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2edfcac630df58604e2fd834aa50c3dedcb75f4520a2c03442c544e7173e516"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de63237e45d1fe69b4745a386127dd1e029f8a66e73a8cbd008d9f0fcaa32ae3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d2116021e7db82c4d1b4dcc145f9505144c12d77207af7aec2adee91b065722"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "962cfa63a65937485bd63ff33b365433c933aa2991ac5b445f2014076b812858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d0de573c1f21e9187ca808d1e028464e63988fb297a204f22cd27e8afa11956"
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