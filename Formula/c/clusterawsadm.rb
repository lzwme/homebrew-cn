class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https:cluster-api-aws.sigs.k8s.ioclusterawsadmclusterawsadm.html"
  url "https:github.comkubernetes-sigscluster-api-provider-aws.git",
      tag:      "v2.5.2",
      revision: "5383d351296ff753f30c861c45275ab83069d395"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigscluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0dcbb0e316bae2849dc65b46f1ac96f85b836fb7c3cb1f9102fa6f371dd62fff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f428d49a7f2834fc114e93f6370df69c0a975d7fe1de8dd2838b0790ca1052ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "390254a7f3726397bccdb9ef2b4fa7dc4fd11d8c0b60b0bfbe1d0f24977b8168"
    sha256 cellar: :any_skip_relocation, sonoma:         "5397fcc19834cea7c5e9ba25a7e1bf5660be5eea7bd3b5ea92592222a9a4929b"
    sha256 cellar: :any_skip_relocation, ventura:        "355764a740e76d0993ceaae4403f6405bd53314073c85da10a3b6d8cadf011ca"
    sha256 cellar: :any_skip_relocation, monterey:       "b473a0421919f08d08192bc2aa5abca05749c6d1b19f42bc39762b42a0e54276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f322e66af5bffb505b42311e690332d703fa2e14e5d27c8a45bc9dd7aab6ef40"
  end

  depends_on "go" => :build

  def install
    system "make", "clusterawsadm"
    bin.install Dir["bin*"]

    generate_completions_from_executable(bin"clusterawsadm", "completion")
  end

  test do
    output = shell_output("KUBECONFIG=homebrew.config #{bin}clusterawsadm resource list --region=us-east-1 2>&1", 1)
    assert_match "Error: required flag(s) \"cluster-name\" not set", output

    assert_match version.to_s, shell_output("#{bin}clusterawsadm version")
  end
end