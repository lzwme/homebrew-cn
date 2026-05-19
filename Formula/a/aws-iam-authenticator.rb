class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://ghfast.top/https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.16.tar.gz"
  sha256 "226f3818fa6fc60489b5f2cbde38a59cf652652378d12afe1ca25e83f2a403cb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f31fe27f01f0af0a702258b92d2a966464c3019563b7ff856321e8e9680a426"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2bb8ae5c533fd2da64d838ead2671335b031db19dc2c1c4b9d1ed4678b91b16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b10afa1e6d20301b491ba3acab5cbcf8a6f93022de75e2dd1e3c2aa03932202"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ff7560b21af8c1686f11d7c24e372b2fb9e792873f049fa5d4330ac57d8c8e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38957f3cc5d5c896b53ba26c2b07080c00d4968cddb0090699b489ba66833426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f80c273837b2b69430b2ead27ee95c1f1877e5a3acd35f29e28ef15ba453a173"
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

    generate_completions_from_executable(bin/"aws-iam-authenticator", shell_parameter_format: :cobra)
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