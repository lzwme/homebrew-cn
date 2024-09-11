class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https:cluster-api.sigs.k8s.io"
  url "https:github.comkubernetes-sigscluster-apiarchiverefstagsv1.8.3.tar.gz"
  sha256 "16fc4e794ae83945b6ad5bf8cb2e298327167880b594aa1d92f4ab70bbba763a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ff1e24f1083d5969bbf6b6d271ee1df7972025b32beff520c6ec6dbaf7ebbdb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e359109d290ac796074125907fe8b17bc9c52def490d075faf450414786c21d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c6d99ec9051fdb24b0a9a8ac73a92a406e6c61b1675e62b622977d60f3d12d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b35d40c55fc09339b9fbbc0836771daf650fcb3507f98bb92ad94b7089a55d6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c99c7246092dd9d8ebc7b47da77172b975602cb9ed1eeedc6f13cf6a82643279"
    sha256 cellar: :any_skip_relocation, ventura:        "f0fa8c829876d60bfc1ccccfa252cf6b4eaf55cfbac1ca6612699ba2c51c7e70"
    sha256 cellar: :any_skip_relocation, monterey:       "7054f13354c7ddee782bb532cdba1c663e4ac66299975d56fce4bcd520770a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "165471d7f30a73f0c737976b28937902d39c98bb652951c25ee546a379d5a1d2"
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