class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https:cluster-api.sigs.k8s.io"
  url "https:github.comkubernetes-sigscluster-apiarchiverefstagsv1.9.1.tar.gz"
  sha256 "5f2197dbfa061f005a8dbd989300b45c91d868a79bd70ccfaffe281ef11e14f8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03457bf96d12c0b112550d487893945e7571e18517deaca94f23b2570cd1550b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03457bf96d12c0b112550d487893945e7571e18517deaca94f23b2570cd1550b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03457bf96d12c0b112550d487893945e7571e18517deaca94f23b2570cd1550b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4445f5d56775a68402c8f67bdbf186ffb16417c6679687b607e8430f637474ec"
    sha256 cellar: :any_skip_relocation, ventura:       "4445f5d56775a68402c8f67bdbf186ffb16417c6679687b607e8430f637474ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08753a7bb4ce74dbbe35659d5470a775e102db584bbfde44c6a25b2c764fe561"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.iocluster-apiversion.gitVersion=#{version}
      -X sigs.k8s.iocluster-apiversion.gitCommit=brew
      -X sigs.k8s.iocluster-apiversion.gitTreeState=clean
      -X sigs.k8s.iocluster-apiversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdclusterctl"

    generate_completions_from_executable(bin"clusterctl", "completion", shells: [:bash, :zsh, :fish])
  end

  test do
    output = shell_output("KUBECONFIG=homebrew.config  #{bin}clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "clusterctl requires either a valid kubeconfig or in cluster config to connect to " \
                 "the management cluster", output
  end
end