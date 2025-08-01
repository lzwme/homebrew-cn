class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://ghfast.top/https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "9f9542cd6d87a46329156f6ab4cc6c87d761afdb06d3081c134387f096e39c21"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f1f2cd1d32d8306e2d79b0cc494616c1a25db0e118f49a7a382c6cf6d1d5f1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e2aa54cc2fe895f288175938c6c4c75069f90decff421d90c11658a71a1d92d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33864ee61abb08da9af9f5e1f48f9d81f03f7a341206792b60ce5cf3f3844154"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0e1b84bebbf3a2f73153bb6f55c9dd68fa022264b9cc3237d7a5917b944098d"
    sha256 cellar: :any_skip_relocation, ventura:       "08458e6d4095dbcbf6740050621e90936cd7599099afaa863551bd3bd18a9f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bf1cea222926640dfe74e9806284cb9e92a9e034c7f86c09a504f51a3b9936a"
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