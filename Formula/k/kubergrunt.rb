class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://ghfast.top/https://github.com/gruntwork-io/kubergrunt/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "3623da856d3136fdbaeb18dee78b957715af1f34ecbdcc1ae388246f44e7992e"
  license "Apache-2.0"
  head "https://github.com/gruntwork-io/kubergrunt.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c92c42cc7988e63ce4da5c0778ef21ada0914eaf4ad717fcefdb9440a13de626"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c92c42cc7988e63ce4da5c0778ef21ada0914eaf4ad717fcefdb9440a13de626"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c92c42cc7988e63ce4da5c0778ef21ada0914eaf4ad717fcefdb9440a13de626"
    sha256 cellar: :any_skip_relocation, sonoma:        "53beab4bc207f4f210f6320a00e6373849d54d8deeca151bffc5aa50aea1ad6e"
    sha256 cellar: :any_skip_relocation, ventura:       "53beab4bc207f4f210f6320a00e6373849d54d8deeca151bffc5aa50aea1ad6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a31c4ca12248553d428ef49350cad310d282bb0d26e149034cb0234c70e15bcf"
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