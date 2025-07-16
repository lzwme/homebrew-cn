class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://ghfast.top/https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "b50e70b68ed5685661296cb877feb9978bb377d3ca1dce4e72541f57a9567aaa"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e9c70a8821dacc6a578f0d6febc6e876625a41b55ae6a4ed252b1ea89acbe93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e9c70a8821dacc6a578f0d6febc6e876625a41b55ae6a4ed252b1ea89acbe93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e9c70a8821dacc6a578f0d6febc6e876625a41b55ae6a4ed252b1ea89acbe93"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cde92a0ef4f8bbb78c379a75e5070527eabff72a61bb2b7b17acfb14b37188c"
    sha256 cellar: :any_skip_relocation, ventura:       "2cde92a0ef4f8bbb78c379a75e5070527eabff72a61bb2b7b17acfb14b37188c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff5c8fcb8169e2d367532b999b36a6ced34028f27bdde935fd6fb2fad15b9534"
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