class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https:github.comkubernetes-sigsaws-iam-authenticator"
  url "https:github.comkubernetes-sigsaws-iam-authenticatorarchiverefstagsv0.6.28.tar.gz"
  sha256 "fd079b9aad27dedb6f5d132e6662aa60a9f7a25580af2d343f89882a4a6222f3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2247afcae2b6628195756935701bc46d873d98ae8678cfd25d86421059079b1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2247afcae2b6628195756935701bc46d873d98ae8678cfd25d86421059079b1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2247afcae2b6628195756935701bc46d873d98ae8678cfd25d86421059079b1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9936a5ea230627da2d38677e48971316c00e8a5904e1f3cd6b29f58d9915b40"
    sha256 cellar: :any_skip_relocation, ventura:       "a9936a5ea230627da2d38677e48971316c00e8a5904e1f3cd6b29f58d9915b40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b1bf56e51287b1dd746f9c047fe21594623a57f8168e69cd9bf7bbb5f390b8a"
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