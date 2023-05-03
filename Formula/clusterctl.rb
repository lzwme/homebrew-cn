class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.4.2",
      revision: "7b92ce4577e36adf013dc1dfd2b239fde4c36bc4"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea5d6ea0636d31f4c168d92c2d6fdb14c3f0291aafc3f6c7cb0b8c1bb397347c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea5d6ea0636d31f4c168d92c2d6fdb14c3f0291aafc3f6c7cb0b8c1bb397347c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5f00efdca9570c0bdef5766e858a26254992f69e54f63a384aa5bc14f55dcfc"
    sha256 cellar: :any_skip_relocation, ventura:        "33669a621e99ab84ca0c8d9a13499745e50fd7e617049405488488b7bdf9a6f7"
    sha256 cellar: :any_skip_relocation, monterey:       "729878a8b0307625c3cdbfcab2ecbc22d5e554b24f91371157d576542c1dd4ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "33669a621e99ab84ca0c8d9a13499745e50fd7e617049405488488b7bdf9a6f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2dbda9737ba1a51bc56e4e3c8e04797f3db769e918956a47fe79a9aac5869b7"
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