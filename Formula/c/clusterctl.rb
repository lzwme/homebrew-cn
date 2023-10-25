class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.5.3",
      revision: "5b7c0f00d7d57d7f6fc385646bb3e79951d82c75"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e679681f13c5906d696d296fdfa555b8719c432c9170141d65429a9b0df65a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69c535bf67fdf72db0410e62a356743198b0de7b2353ba444f438248980f7af0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b395103c3db4ed98e183b5067e8eba87bcb12c1acc7de3f8f2b8815d8ec2bb4"
    sha256 cellar: :any_skip_relocation, sonoma:         "6769b99c039bf7bca20a22e36646f06df22cea914c08abfc5605e5c6cecf120a"
    sha256 cellar: :any_skip_relocation, ventura:        "3801005f12bce8466983aa908a9dd22d1f419e06377bdf5721f3e0b2268d6085"
    sha256 cellar: :any_skip_relocation, monterey:       "405148fdd409da28983350b15633e36f4ee116042490884a4a2367bdbb03c541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f358c0e9fc2ac0d24a550e3654c140df79e130be52da4acc08942d9aeca00f2f"
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