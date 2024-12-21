class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https:cluster-api.sigs.k8s.io"
  url "https:github.comkubernetes-sigscluster-apiarchiverefstagsv1.9.2.tar.gz"
  sha256 "d4b6974ed15b8d7a3cd2e314087d275af6ee5133de468afb8a6e7e1451bd7d28"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dbcc7cb17cf3a9ba9dd08bb9c0d789a9844c454432689cfd17bc07534342296"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dbcc7cb17cf3a9ba9dd08bb9c0d789a9844c454432689cfd17bc07534342296"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2dbcc7cb17cf3a9ba9dd08bb9c0d789a9844c454432689cfd17bc07534342296"
    sha256 cellar: :any_skip_relocation, sonoma:        "760fd80efb25ad5ebdcf2583ed1ea29b09047d75cf74743718d014e46e919d14"
    sha256 cellar: :any_skip_relocation, ventura:       "760fd80efb25ad5ebdcf2583ed1ea29b09047d75cf74743718d014e46e919d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8dd08c6f4202ebe37ef40cc379ac14fcfe329822216064e4e1f97303c05b6e8"
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