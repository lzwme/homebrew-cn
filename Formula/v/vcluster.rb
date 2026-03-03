class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.32.1",
      revision: "9d2cec33373e093beeec9e17a0bbd71eec39eda1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d196ca0611cbd1529b4a72ae6f8efd882381754932676d1ff7f7b7e882ed4751"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4563ca180fc3f27c2235013fb8bfa92f3708064d62b111a19f10900227a9abbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1ac78ec6b5f773004c4689e2e74a2bddc412de1973f5d4abe415298820717cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e138ae11ea0259f4c2ab60784191ae83873c7ad1927e1b660aca7682c02b650"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b22b4e19e58dcf19daf62dfc4b0833b87bcfde2f3b362508975c6e65d3cf322f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f80c7db3b9515adad2bdb61d71dd537931bcdeec305bdc573ab77bebb4b3002e"
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