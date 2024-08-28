class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https:github.comkubernetes-sigsaws-iam-authenticator"
  url "https:github.comkubernetes-sigsaws-iam-authenticatorarchiverefstagsv0.6.26.tar.gz"
  sha256 "ff102424fde0f4da75a8c21c89757fb94b04460cadf1949d9a5985e5826bfa1f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fd36379d4c213bf42a4d86a6b2cc5adf808f47456b3f0181a0621a0ae1df258"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fd36379d4c213bf42a4d86a6b2cc5adf808f47456b3f0181a0621a0ae1df258"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fd36379d4c213bf42a4d86a6b2cc5adf808f47456b3f0181a0621a0ae1df258"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c53a2c1a7d6ae0b747d658d4b09b84fd36fd54cd4172da23b4e7941c1c8e30f"
    sha256 cellar: :any_skip_relocation, ventura:        "6c53a2c1a7d6ae0b747d658d4b09b84fd36fd54cd4172da23b4e7941c1c8e30f"
    sha256 cellar: :any_skip_relocation, monterey:       "6c53a2c1a7d6ae0b747d658d4b09b84fd36fd54cd4172da23b4e7941c1c8e30f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bcf8a265865630154155861eebb0f2d69c8c6a1e1d099b75e943d0a2af09107"
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