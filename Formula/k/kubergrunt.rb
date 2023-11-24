class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://ghproxy.com/https://github.com/gruntwork-io/kubergrunt/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "88e8162f86d5bfd7548a84bdb80db7490b8176c4aed776da087078e5e78e6d6a"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29784598ffe5317c9eebf3082e20b7b0384d060f2d10b576c3c22e6510c80ec2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ceb8b019436065df349c62d93820c1cebea3a08cc0468130c93cc51f84929c25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3be2017a5865dcbbfed9ce181c38bc5a1024b2651b311b35fdde604a9e31122d"
    sha256 cellar: :any_skip_relocation, sonoma:         "98dfb5528aeaaa24ce4157afe43b124023d1f7b46179ce1c3e4d05a40af892b4"
    sha256 cellar: :any_skip_relocation, ventura:        "49f9b38dff5b49affe54195c60520695ed91999af54e4a42d34cb550725541fa"
    sha256 cellar: :any_skip_relocation, monterey:       "317557a84280998fef5f14e9b5362565489c3b15c9b94ddc6bc5032dd58f8397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8415d04eb5200d8f287e0ab856804f98b438830c8868590372c0b1b7cabe47b0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}"), "./cmd"
  end

  test do
    output = shell_output("#{bin}/kubergrunt eks verify --eks-cluster-arn " \
                          "arn:aws:eks:us-east-1:123:cluster/brew-test 2>&1", 1)
    assert_match "ERROR: Error finding AWS credentials", output

    output = shell_output("#{bin}/kubergrunt tls gen --namespace test " \
                          "--secret-name test --ca-secret-name test 2>&1", 1)
    assert_match "ERROR: --tls-common-name is required", output
  end
end