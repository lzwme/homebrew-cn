class Clusterawsadm < Formula
  desc "Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS"
  homepage "https:cluster-api-aws.sigs.k8s.ioclusterawsadmclusterawsadm.html"
  url "https:github.comkubernetes-sigscluster-api-provider-aws.git",
      tag:      "v2.8.1",
      revision: "49c75acbea08e311e48c1089c78d65ac5aabe42c"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigscluster-api-provider-aws.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8da950865a1f41e10a56222a44a47f7cb5b3c6dfc0abb96e6ec74d1da0c95c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d0765472ef08ddbba6cb2d7fe685696e1d235e8584506b63d5e654970a26000"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de7ec8f561d0a70866d1c96b9015c31ad5f200e7e3c316f8fe0c0fda41ff7e50"
    sha256 cellar: :any_skip_relocation, sonoma:        "99331a1fc9d5e33bb0d19abe53a1d3662bb105331d4b0bc9d2060db2b7cdbbd1"
    sha256 cellar: :any_skip_relocation, ventura:       "1ebb71ce7122bb1b6993d6492f76e0e871e9a174dd51796c8b50199f5e95f857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd88195a18ce6fb667bceee146edab56eccdf596271132c66efcc7a4bddadc68"
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