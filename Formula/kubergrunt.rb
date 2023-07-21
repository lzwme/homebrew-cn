class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://ghproxy.com/https://github.com/gruntwork-io/kubergrunt/archive/v0.12.0.tar.gz"
  sha256 "6744144aff555363aff8e39c5d9f4c3da14f45651cc7dcaa588a6af6e8e9753d"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63abe2b4a54a1e23523f682889d60cfa7af14a7f25c7782ee373524a55c20cae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63abe2b4a54a1e23523f682889d60cfa7af14a7f25c7782ee373524a55c20cae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63abe2b4a54a1e23523f682889d60cfa7af14a7f25c7782ee373524a55c20cae"
    sha256 cellar: :any_skip_relocation, ventura:        "bbfda8c965e9c350423ad7942f7cf99dab8b7ad297b3a82056bbebbdae95af6b"
    sha256 cellar: :any_skip_relocation, monterey:       "bbfda8c965e9c350423ad7942f7cf99dab8b7ad297b3a82056bbebbdae95af6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbfda8c965e9c350423ad7942f7cf99dab8b7ad297b3a82056bbebbdae95af6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b05a09f8ec0f5e3eb7ffc60080a7ec52bb858345695dd1f65ab962157b79e693"
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