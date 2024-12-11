class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https:cluster-api.sigs.k8s.io"
  url "https:github.comkubernetes-sigscluster-apiarchiverefstagsv1.9.0.tar.gz"
  sha256 "0105931512aa9098f6d8ac2f21e05013448b44085eed2bcf7a7dd1d864d1fca3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a88e067a42859ebe51466a64071f2a5a18d79d8e858052286a6ab4a21f859e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a88e067a42859ebe51466a64071f2a5a18d79d8e858052286a6ab4a21f859e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a88e067a42859ebe51466a64071f2a5a18d79d8e858052286a6ab4a21f859e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e055a7bd4c917e4f0e44763d035d5ecdce607e4574eada577042b4de80460ac8"
    sha256 cellar: :any_skip_relocation, ventura:       "e055a7bd4c917e4f0e44763d035d5ecdce607e4574eada577042b4de80460ac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70ddf5bd506ab71de40f8ece291878e4081d23f09d07daecfda30c83bf8a64ff"
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