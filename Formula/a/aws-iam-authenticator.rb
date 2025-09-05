class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://ghfast.top/https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "7dcb236766f80b9edbbf3bf952ec81e5d90adbcf4edbd02a143359b37491b035"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "742acef716cc4961592f59844338db8cbe80a29785582b34677bfbb019d6b529"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f28d553ead855b98718c72347799a7d2538e3dc3f184bcbbb2414b121a502096"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f2c5826d18647de188a951fcf0066fa6a0e7cb4d560225e556e96dbc7683035"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff11b647e55158214f2ad89e69e6b08656ad1afe3ded5ec79f1dc977b61c2ab6"
    sha256 cellar: :any_skip_relocation, ventura:       "1498c491503a2c68620573ccd588136d2c3ddb51f3bb89564a45bf4db5471e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7314b6eca47f72103c9ef8f8cab91971d47243f567533270002aa84f884ffb0"
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