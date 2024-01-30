class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https:github.comgruntwork-iokubergrunt"
  url "https:github.comgruntwork-iokubergruntarchiverefstagsv0.14.1.tar.gz"
  sha256 "c9cd2abb50a2e0aae8a503a8034cdef99e0ecab796f47b752762a5e18c59124e"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3c086bdfcafff052b1c2b50d895fab1f04efc2f0cfe370bbb4ae2094d5b7472"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "516f1b7dbf566e3a021ef2f9ce17daba3bdf224a6a7a54447d779b9186202579"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ec0f93a9614c34f2f0d3c5a9de697c5e7bb312b4eab1d9b145eb683b4e1681c"
    sha256 cellar: :any_skip_relocation, sonoma:         "0dd8488e6dc91c6ac938dbdeb40f1693d505f46a513574195b96ec998728707e"
    sha256 cellar: :any_skip_relocation, ventura:        "d6004867e7e55e48a93008a2a7ddbbb3368844ddec959356049be5f619401684"
    sha256 cellar: :any_skip_relocation, monterey:       "ecc57e1738db620f9edca80e869dc194730be86a9599d509f97fdd95c9d529c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac52a60dde0e641191b0eadc3f105537f791e7387c0869323f3492b05df367ec"
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