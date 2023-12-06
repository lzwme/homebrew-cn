class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.6.0",
      revision: "14efefeb46dbe8d0cd0f5b7d1718e00ec58fc079"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api.git", branch: "main"

  # Upstream creates releases on GitHub for the two most recent major/minor
  # versions (e.g., 0.3.x, 0.4.x), so the "latest" release can be incorrect. We
  # don't check the Git tags for this project because a version may not be
  # considered released until the GitHub release is created.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d31b06b2e4715ab78df65bb84ae2f2d1f3fcc6eba19524693c87744f565f1bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "331caab1745f3c7390f83bbb6fc9f972d2a7bb52be9e69b375911351a233ed94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c6321fd3b79db60869a698c130e795be1de226efa6393ff360317312f8011e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "ceb3b8c875a5f3e22d9ebcaf2003aeb3126ae7536e18140c8eebe7f12b9a5da9"
    sha256 cellar: :any_skip_relocation, ventura:        "b3fefc98e2381ed81c56854ac5848bc23d803db454feb96170498b14b4da7e1d"
    sha256 cellar: :any_skip_relocation, monterey:       "8631e72490743b5054f1710dc7bffcf9526ea4e62aca330bff24c9721736092b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1368601683899a065ace7cc11dbf90849c34a602d66d62ab231aa2ed62cbfd96"
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