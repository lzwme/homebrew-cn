class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://ghfast.top/https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "9b5d8f09553998ef168b05d831bbbcf20b40bc974309eb16d88363531734a589"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b268e38ea70df1766a80ed4c63508787b1af9bdd012616ac918a34bb18e87622"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5333d683d4e5579b4ae162fd1bda298fc95571234b80d02bd29e95fad28f742e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f31aac967863adcecf3eda175f8f04fd0a0a1bf92f9162453f477892a74c0ff7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d675723187c43c90ad3dcf61ada2aaaf99c7b6440436cedf7eedaad614506110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ffdbd19f1718d8f724c131e60d3dbd498065e2d5af634051fbd30313a0474e8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/cluster-api/version.gitMajor=#{version.major}
      -X sigs.k8s.io/cluster-api/version.gitMinor=#{version.minor}
      -X sigs.k8s.io/cluster-api/version.gitVersion=v#{version}
      -X sigs.k8s.io/cluster-api/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/cluster-api/version.gitTreeState=clean
      -X sigs.k8s.io/cluster-api/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/clusterctl"

    generate_completions_from_executable(bin/"clusterctl", "completion")
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "clusterctl requires either a valid kubeconfig or in cluster config to connect to " \
                 "the management cluster", output
  end
end