class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://ghfast.top/https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "834f0b38eec0aac72d78aa07d4f970519f898c7a18a97f94ab0bb9b740730436"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git", branch: "master"

  # Upstream has marked a version as "pre-release" in the past, so we check
  # GitHub releases instead of Git tags. Upstream also doesn't always mark the
  # highest version as the "Latest" release, so we have to use the
  # `GithubReleases` strategy (instead of `GithubLatest`) for now.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "373bbaefe7cce1b2a7343f89967d0626ef3835d9f76e104f3107ab5f6ccc085a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d6228e8350e2412b7f0475837d9bfe4b16271d59e8da0bf6f07effea7345b60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "258995a7bb935f7f65dffae2f1ba652de6810028360ba787ff91289ecfd62b41"
    sha256 cellar: :any_skip_relocation, sonoma:        "dea373f24c54f54bbc4bd50d9c51d86053a9888e4ec0ad588cd2c2635cbbff4d"
    sha256 cellar: :any_skip_relocation, ventura:       "6c8179d352f7612a1f1d37b125e61add0990574f77cfa4aadd6120a8d7a79522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6209eb41691bbfec658bb43d14b1b274c411f520773f87533f79d11d595b19c3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/aws-iam-authenticator/pkg.Version=#{version}
      -X sigs.k8s.io/aws-iam-authenticator/pkg.CommitID=#{tap.user}
      -buildid=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/aws-iam-authenticator"
  end

  test do
    output = shell_output("#{bin}/aws-iam-authenticator version")
    assert_match %Q("Version":"#{version}"), output

    system bin/"aws-iam-authenticator", "init", "-i", "test"
    contents = Dir.entries(".")
    ["cert.pem", "key.pem", "aws-iam-authenticator.kubeconfig"].each do |created|
      assert_includes contents, created
    end
  end
end