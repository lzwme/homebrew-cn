class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.4.0",
      revision: "2c0771782941d624e6281c953ffb33413ce9106a"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api.git", branch: "main"

  # Upstream creates releases on GitHub for the two most recent major/minor
  # versions (e.g., 0.3.x, 0.4.x), so the "latest" release can be incorrect. We
  # don't check the Git tags for this project because a version may not be
  # considered released until the GitHub release is created.
  livecheck do
    url "https://github.com/kubernetes-sigs/cluster-api/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e892a445f606f021593885d1acf43c027e999397af852f2d2852855d24d5a9b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e892a445f606f021593885d1acf43c027e999397af852f2d2852855d24d5a9b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e892a445f606f021593885d1acf43c027e999397af852f2d2852855d24d5a9b2"
    sha256 cellar: :any_skip_relocation, ventura:        "a29ba9c502ccc94d7165c57bb748154ce19df7f96df568ded9f7ec66592ebb50"
    sha256 cellar: :any_skip_relocation, monterey:       "984ef5940599539b3dec1db852aa3d251b156cc357e16f3722481aeb59ff87e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "a29ba9c502ccc94d7165c57bb748154ce19df7f96df568ded9f7ec66592ebb50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9acfbd9885f1b27002a0aaaf22fdf87b49fb229827ad1b31c6d35cec7e2686fc"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "clusterctl"
    prefix.install "bin"

    generate_completions_from_executable(bin/"clusterctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "Error: invalid kubeconfig file; clusterctl requires a valid kubeconfig", output
  end
end