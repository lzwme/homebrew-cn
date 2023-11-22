class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://ghproxy.com/https://github.com/gruntwork-io/kubergrunt/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "8868eeb9baf061ea0a3468bfcf62fda971a2e7e71d1dc7171ef256bfd7d93904"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb31ba63d588ac954eac35101ee88fdf1268f2ddf0e5532112d6f316c09b8027"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d36a2622a0c75540c6653de5698291da616f9397da9f6e3a6c0b1ea5426968b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8eeb1544fe0df0c8f64754812a0eb034c6afe489dfffb024d14583e332d67f1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "baa5321bb78e551232e7bd096d7afa72cbecabe0c3f3ac528cbed639ddd28902"
    sha256 cellar: :any_skip_relocation, ventura:        "962b39ae4ec269f397808a3ce4f652e0f1983b1dc63932f7e564ab9fcd7210d0"
    sha256 cellar: :any_skip_relocation, monterey:       "0388fd2a189f9ddfd60f5ba115059adde5de1b4e689b973c70f25da605c1f1d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e62f4cea51436fcafb0d92948578543f2ea3f6795fd84c2ccf675320785687f"
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