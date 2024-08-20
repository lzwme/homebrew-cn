class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https:github.comkubernetes-sigsaws-iam-authenticator"
  url "https:github.comkubernetes-sigsaws-iam-authenticatorarchiverefstagsv0.6.24.tar.gz"
  sha256 "50d8bfe898984e0748888d9e4d6d87e20ebeac17cc4d397bd67fa56c3aed93b2"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "defcc143b7fc8235bc63843815f7f951043df02b497356c3e51ddb7f738ca401"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "defcc143b7fc8235bc63843815f7f951043df02b497356c3e51ddb7f738ca401"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "defcc143b7fc8235bc63843815f7f951043df02b497356c3e51ddb7f738ca401"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f19268b802e4ede6d33e7783be0a0082d16f04e5ed53501c5193d60ee58ed11"
    sha256 cellar: :any_skip_relocation, ventura:        "9f19268b802e4ede6d33e7783be0a0082d16f04e5ed53501c5193d60ee58ed11"
    sha256 cellar: :any_skip_relocation, monterey:       "9f19268b802e4ede6d33e7783be0a0082d16f04e5ed53501c5193d60ee58ed11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c94afacfff349c7190120b1a6ad553e89572dde3f238617cc951b8f0a9d0460d"
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