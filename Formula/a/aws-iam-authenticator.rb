class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https:github.comkubernetes-sigsaws-iam-authenticator"
  url "https:github.comkubernetes-sigsaws-iam-authenticatorarchiverefstagsv0.6.25.tar.gz"
  sha256 "774e745d27f8ec9b3aea3a23939ec1647ef13c6c47f6ac1ae2d6ac7f5effc117"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigsaws-iam-authenticator.git", branch: "master"

  # Upstream has marked a version as "pre-release" in the past, so we check
  # GitHub releases instead of Git tags. Upstream also doesn't always mark the
  # highest version as the "Latest" release, so we have to use the
  # `GithubReleases` strategy (instead of `GithubLatest`) for now.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6048ce90f24efab455b9912aab0d82fa115828b6a04b7c927e7327907aa2cda4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6048ce90f24efab455b9912aab0d82fa115828b6a04b7c927e7327907aa2cda4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6048ce90f24efab455b9912aab0d82fa115828b6a04b7c927e7327907aa2cda4"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf0b1254a51828232ee39d66069a9d17e20aa7da8e9d304a801380144f933364"
    sha256 cellar: :any_skip_relocation, ventura:        "bf0b1254a51828232ee39d66069a9d17e20aa7da8e9d304a801380144f933364"
    sha256 cellar: :any_skip_relocation, monterey:       "bf0b1254a51828232ee39d66069a9d17e20aa7da8e9d304a801380144f933364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0401665f626946a9324736fefe7ca2e7981bc25af9acdbd3c81d0dbd88baee6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.ioaws-iam-authenticatorpkg.Version=#{version}
      -X sigs.k8s.ioaws-iam-authenticatorpkg.CommitID=#{tap.user}
      -buildid=
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdaws-iam-authenticator"
  end

  test do
    output = shell_output("#{bin}aws-iam-authenticator version")
    assert_match %Q("Version":"#{version}"), output

    system bin"aws-iam-authenticator", "init", "-i", "test"
    contents = Dir.entries(".")
    ["cert.pem", "key.pem", "aws-iam-authenticator.kubeconfig"].each do |created|
      assert_includes contents, created
    end
  end
end