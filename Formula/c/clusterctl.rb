class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https:cluster-api.sigs.k8s.io"
  url "https:github.comkubernetes-sigscluster-apiarchiverefstagsv1.7.2.tar.gz"
  sha256 "873ce3ee1f351afa2ffaebc3a2e0bfb38cd8af198a5b1615d9e43b671f438c1c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3c6fd03a140c8c69f1568720247375a097e25818e491cc970fd7adb70a88d6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ceef88a957b162844b9f96cdd6e2280a6355c8c19598a9fa47656d5008266706"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f68468017a837672deaa2b624cda24a4797be297607d3bfc8a05e952d83ea60f"
    sha256 cellar: :any_skip_relocation, sonoma:         "094042c057c8d9a48d4ae7ef6530698fb6fb9ddfd3d1b9aed83c9cb88f3a91a5"
    sha256 cellar: :any_skip_relocation, ventura:        "d38ef2959855908f337def6b58a68d2c7d52aac03c0094e1126d7a0c72413191"
    sha256 cellar: :any_skip_relocation, monterey:       "86ab1f15a99df03ab9bee8d3a711a28bfcd7ae440427d590e11b62f7f4a27cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b562db95042c09e60f6a9929539f4cfbaa6b8a1c3ace1a916cb9cd9bce91aeba"
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

    generate_completions_from_executable(bin"clusterctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("KUBECONFIG=homebrew.config  #{bin}clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "Error: invalid kubeconfig file; clusterctl requires a valid kubeconfig", output
  end
end