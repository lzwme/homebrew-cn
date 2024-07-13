class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https:github.comkubernetes-sigsaws-iam-authenticator"
  url "https:github.comkubernetes-sigsaws-iam-authenticatorarchiverefstagsv0.6.22.tar.gz"
  sha256 "ac9116aefdbdee001249c5db55c17057b3df2a121bfccf7551c91d9d83daf85e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ae552fde609c25ddb65bd5d4f0f122f9b180f3721a6c153daa9ce449167d297"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "611331b40564e34d5480cf77453e7c950011c0229732c8853eb9452fb0d4180b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f3e52db75228405430916dac427ad59ce9df145ba24c3c9943d1231d330a74c"
    sha256 cellar: :any_skip_relocation, sonoma:         "078fb8e5698ef773bfb08ea8426ee09f2dbeb55b13ed0ab610230eef9fa5530e"
    sha256 cellar: :any_skip_relocation, ventura:        "b0b10a944af2be64c1358742647f7733e58dccdb9f577967c33e2b35425c2536"
    sha256 cellar: :any_skip_relocation, monterey:       "8f0a47c6be9482bb635750c031a03d36403b3f236ff6cbccd274a956ef0304a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0ec4460c2d7d8b89762364eaac38e175f61a10ac19dd1e7bf7338d5df83285b"
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

    system "#{bin}aws-iam-authenticator", "init", "-i", "test"
    contents = Dir.entries(".")
    ["cert.pem", "key.pem", "aws-iam-authenticator.kubeconfig"].each do |created|
      assert_includes contents, created
    end
  end
end