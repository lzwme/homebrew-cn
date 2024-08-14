class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https:cluster-api.sigs.k8s.io"
  url "https:github.comkubernetes-sigscluster-apiarchiverefstagsv1.8.0.tar.gz"
  sha256 "b847b043c6273911fd2b7adc97558c4292c720ebb20798eebe0cb21ae46b05e1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5da561a8fb5e418f8c8e6719f7305d0ff32ea83fbd808acc3841e027ce7c0bae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4428f2e74b025cb6f9f723448ae10f7e4fab8939daab8c3485cce77016b115a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e96578ae006e6bd61a8e7d54f0c7c27a1eee80b211f00719a0ecd1413c8c907b"
    sha256 cellar: :any_skip_relocation, sonoma:         "30b4142803e94e3751531512a19967465400e4c4ef7092b91bdd4dc4ff9e2c76"
    sha256 cellar: :any_skip_relocation, ventura:        "9b24db8e06f9631c8d3dec33c7f6d7cf92fcae12389fc2503b6fbe5d83a25582"
    sha256 cellar: :any_skip_relocation, monterey:       "de4db8fe247e7baaa6f35829f62dddf36cd138d7a9d4f1eb85fff41b96fe03a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "980910f7e9fdea496181ea3cb77eb7aff155e0147e3b61c949422810f56cd433"
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
    assert_match "Error: unable to load in-cluster configuration, KUBERNETES_SERVICE_HOST and " \
                 "KUBERNETES_SERVICE_PORT must be defined", output
  end
end