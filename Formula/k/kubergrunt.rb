class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https:github.comgruntwork-iokubergrunt"
  url "https:github.comgruntwork-iokubergruntarchiverefstagsv0.17.1.tar.gz"
  sha256 "f5a555629f8ac409c3e26b33e02d065441c6432cbc10ff258ce43136499a8506"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48e854c4da10fe4467baf9fe96aabab5be2ac264d7fe6598699525e6db456669"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48e854c4da10fe4467baf9fe96aabab5be2ac264d7fe6598699525e6db456669"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48e854c4da10fe4467baf9fe96aabab5be2ac264d7fe6598699525e6db456669"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fd464ac36a7aba96cf3d23b91bc7d2278c6942d1d8ca18459f4db17341b79b6"
    sha256 cellar: :any_skip_relocation, ventura:       "1fd464ac36a7aba96cf3d23b91bc7d2278c6942d1d8ca18459f4db17341b79b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b99d406cb8db940112df661f189df81bfa13e94415220323fbd1b38abb5d48a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}"), ".cmd"
  end

  test do
    output = shell_output("#{bin}kubergrunt eks verify --eks-cluster-arn " \
                          "arn:aws:eks:us-east-1:123:clusterbrew-test 2>&1", 1)
    assert_match "ERROR: Error finding AWS credentials", output

    output = shell_output("#{bin}kubergrunt tls gen --namespace test " \
                          "--secret-name test --ca-secret-name test 2>&1", 1)
    assert_match "ERROR: --tls-common-name is required", output
  end
end