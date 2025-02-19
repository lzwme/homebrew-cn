class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https:cluster-api.sigs.k8s.io"
  url "https:github.comkubernetes-sigscluster-apiarchiverefstagsv1.9.5.tar.gz"
  sha256 "24b94a9abcb508462936e386594851a5f3ade4503853dc7ab69ddaa3b8bbfd66"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigscluster-api.git", branch: "main"

  # Upstream creates releases on GitHub for the two most recent majorminor
  # versions (e.g., 0.3.x, 0.4.x), so the "latest" release can be incorrect. We
  # don't check the Git tags for this project because a version may not be
  # considered released until the GitHub release is created.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b65407307df4847049860beff8fceb6f3897a10cbc5b12a234246485c752b2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b65407307df4847049860beff8fceb6f3897a10cbc5b12a234246485c752b2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b65407307df4847049860beff8fceb6f3897a10cbc5b12a234246485c752b2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6689fdbdeb6a710c7dfdde174865ca832e11540a6fb7c7fcf24526401a035ce"
    sha256 cellar: :any_skip_relocation, ventura:       "d6689fdbdeb6a710c7dfdde174865ca832e11540a6fb7c7fcf24526401a035ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd40533ff83aef78f6ea08ba8c8ec34b69be8750f883108a7adbd01d83393dd7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.iocluster-apiversion.gitMajor=#{version.major}
      -X sigs.k8s.iocluster-apiversion.gitMinor=#{version.minor}
      -X sigs.k8s.iocluster-apiversion.gitVersion=v#{version}
      -X sigs.k8s.iocluster-apiversion.gitCommit=#{tap.user}
      -X sigs.k8s.iocluster-apiversion.gitTreeState=clean
      -X sigs.k8s.iocluster-apiversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdclusterctl"

    generate_completions_from_executable(bin"clusterctl", "completion")
  end

  test do
    output = shell_output("KUBECONFIG=homebrew.config  #{bin}clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "clusterctl requires either a valid kubeconfig or in cluster config to connect to " \
                 "the management cluster", output
  end
end