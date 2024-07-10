class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https:cluster-api.sigs.k8s.io"
  url "https:github.comkubernetes-sigscluster-apiarchiverefstagsv1.7.4.tar.gz"
  sha256 "c0acb1626a3948107db8131aff01900f9f097fc0b854ef5792fcd91dd324e4f6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a35e639cc425ba10d348974939fa08e462736b0ad160cb31eea837196b7bb5d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f53d9d204550a03d63d36a77d90bb7a9b7e7c42781960e351e2822814e05de8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "879aae0884d3a7e9a99c4e75d70647ac128b129e57f8d35cffb33cd93ad05439"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8c939248fb199debb70f21cc528d8a6dc0aa49507d5579d53de223650647c38"
    sha256 cellar: :any_skip_relocation, ventura:        "26180c54da7062ebf3e063a018333b639201760418c96c72f26124bde168cd59"
    sha256 cellar: :any_skip_relocation, monterey:       "e4cc00c0902c2c081481dfea3efe4c0ac29b3090edf19c8ab51a1b390c879f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb9643e9dedb2e750a665e7044aca7d208e546969872c54158ee689bcc7cb7ae"
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
    assert_match "Error: invalid kubeconfig file; clusterctl requires a valid kubeconfig", output
  end
end