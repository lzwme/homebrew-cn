class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://ghfast.top/https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "c6541b06798f93255924b4e8d5a11e9bfeda824d181e8875b29b488e8605eb75"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a56e3bdd73bcc4a6928e951ea3f0826d169b049f2fd6e9921a4b8679e4f8a854"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fdd452ff485fb4ffd06cae3fa6a9f92e270106b9320568c1c0a45cfa1ccad99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48ae0978c90059617f4c1431df48c165c9fe204233efcf962520339e02f6ed3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bf187347e8f182a64423d696265121b81e6c6c4083715eed1151913f591baf8"
    sha256 cellar: :any_skip_relocation, ventura:       "95646c3317436db5531e06cfef6b30900cb2a327412af9c0da1e6a1d56de1c29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6086805fbd4ed5bf4e134df3f6641d47460f8e3ddd75cee83315d2ad9208cd39"
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