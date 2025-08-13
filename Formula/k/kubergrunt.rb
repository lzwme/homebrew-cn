class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://ghfast.top/https://github.com/gruntwork-io/kubergrunt/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "f1a66d56018d531002eba414baca9f7e56417ca17e24e60ccfe42bb23cff3e04"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ff39366f9b15f17a7d06efbd707df318be5fe82cef35299f23db514c9dab074"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ff39366f9b15f17a7d06efbd707df318be5fe82cef35299f23db514c9dab074"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ff39366f9b15f17a7d06efbd707df318be5fe82cef35299f23db514c9dab074"
    sha256 cellar: :any_skip_relocation, sonoma:        "35206434257bfed2dae0d13eb4c523e052a4c183ec665b6b9d907aa068d3bdbe"
    sha256 cellar: :any_skip_relocation, ventura:       "35206434257bfed2dae0d13eb4c523e052a4c183ec665b6b9d907aa068d3bdbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab1c1173149053245a53a7a10a62047bfb348b26dfacb29417634038649e2c5b"
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