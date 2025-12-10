class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://ghfast.top/https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "6ea5cc840dcb78147b04e77f6781f4e6878e17de03052c93c840c0d5c7fa7dc9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ad6a5567e2438f435f461d9951b615a6a843a01af5cc5b13183aa987947a0c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59bc922ee811c8d4111592f3333d3eb2220d5b5ba15cd689b6076b61dc942a12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb441cadc1b61cf4c80ed63d483b53fb1bd09b537c7d8c1ea86f6839e983a05f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d825601126e68a5c4231d931b2e08fe5b5e6ec36c0d7469d5141d08bcd0d135f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6f84753b5e2b7c6bf6c4d4a8639b6e9952855e020fde8c830d5dc56735c1c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44cbb7f12a7bd1fc9a0fe6ed44259c03def408c00b0221ecba080487e7fb0063"
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