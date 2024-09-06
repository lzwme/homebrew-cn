class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https:cluster-api.sigs.k8s.io"
  url "https:github.comkubernetes-sigscluster-apiarchiverefstagsv1.8.2.tar.gz"
  sha256 "fe1e93d98fd231bed3b64603a78abb76f38b2f5b72af6f5403a029264cd7a4eb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d046bea5096c17b182fedf8b067fef7ad174e74da1ff8f977535bac4642149b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd266c6043330e85222544b5a5c74ca5ddc748ea73bbfc40499043894c340e9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edbdcdb93a87f1d7c0fcc860a24e32b9932b08d094584a16a36ec348e8fc9498"
    sha256 cellar: :any_skip_relocation, sonoma:         "98ef47f2aa18a10b39473662847353775d47902c5ead66bae580dff4032439ce"
    sha256 cellar: :any_skip_relocation, ventura:        "8d821b0e50d240c3aab84c86510ae8b318cd1c908bbbb01da491382526bbe66e"
    sha256 cellar: :any_skip_relocation, monterey:       "d7efdb3fa45bf8e245bc6265cedf40fffcb410275f1b5d121605ea5b640602a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d02fb2e2132ab095e344a02933e2142ca80c1618db1c667c7cdb6401fb9e19e"
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