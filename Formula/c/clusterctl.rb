class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https:cluster-api.sigs.k8s.io"
  url "https:github.comkubernetes-sigscluster-apiarchiverefstagsv1.8.5.tar.gz"
  sha256 "ddf3034d93af6da086791bdfd8ddfa1101e03080e81e41ac8a9d1ebfc57f6e06"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05428df05da7552b596f083638695f62d4ea6732c7f6488a150b927e8d4bda4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60f46a963688ab4aa7e70e2fabfa7bd2744f4d6eaba0aa8f7d6992cbcc0f8a6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e524218ef69908f1db5f05b63bcb7c889a29def6da569d1f2d4a881e29dbdc50"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fcb1780603f0a9e0dc9008d9c1cc7e2604ebecd6ba8447cee201be9c510a8a9"
    sha256 cellar: :any_skip_relocation, ventura:       "b3ce43f69a107e82d99ef1382e4f62467a26d8def282e91c5468d0199231afd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26af4cd0cf2b17cc953abae4606f4d217f26b2266bf4a4282c0378f083eb64af"
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