class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://ghfast.top/https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "79a29650c75bce98ddf04e93370090d35f42011aa8b30818b742946d6d51838b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6455ad58ef02d09ba083e540d15f5fe40ea3c6b187d8efb244dfd042c0508c3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad8777b161e0c913cfb29ef68068ba58282f7c9dacd77e19f5c1238afa7b92d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcc358227d57fa910960033b6d57ef0e0398d450f79cca4e44d78fd95c39f45d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e194b5c2becb9f20b506b12184c708f56ecede8145e051f8ecd8592bed41401"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "850106bd56bad8ef35356cf1b4779cfdfce6212bb072278c4bdbe17b945a95b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb958ddbdbee980dcff3dd128c41223a7d5b87c07287560de34450b0f38d8553"
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