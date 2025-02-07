class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https:github.comkubernetes-sigsaws-iam-authenticator"
  url "https:github.comkubernetes-sigsaws-iam-authenticatorarchiverefstagsv0.6.30.tar.gz"
  sha256 "58fa10087b795a8bb3da06ab8739a4709b09d53d8ea55b48994b4f34a3c61220"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e6e54fc32061abee0d25db3ba1b1db5519ee2cbb0a62e111e338b2667d407f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e6e54fc32061abee0d25db3ba1b1db5519ee2cbb0a62e111e338b2667d407f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e6e54fc32061abee0d25db3ba1b1db5519ee2cbb0a62e111e338b2667d407f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e37f280e8045997d0b067ad2f7eedd032edc22f801eeb43d471beae221409941"
    sha256 cellar: :any_skip_relocation, ventura:       "e37f280e8045997d0b067ad2f7eedd032edc22f801eeb43d471beae221409941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3817dfb8c2208837d7f06817a91a88ae848c210348aa9768f781d20de389f53"
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