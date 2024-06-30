class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https:github.comkubernetes-sigsaws-iam-authenticator"
  url "https:github.comkubernetes-sigsaws-iam-authenticatorarchiverefstagsv0.6.21.tar.gz"
  sha256 "0358a392f49fba10301815b41f97abe99ab9c0e26f4c1a93aca2051241575303"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f2a17527f11b0f7455021babb08b0430be64134ecb963f023b93d8bbc7abf43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "570f0f702c95c7dcf4238c572f13d8a9becf6a13730a72b69261009ba3724301"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7f425cd8e7854d8eaba4be358eb255ba364234e47c6959d1a344289d53abb2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0836b39a2617d508fc461998b1fc0d9677d745ac1f993a82a91f5611ddd17df3"
    sha256 cellar: :any_skip_relocation, ventura:        "2f1392a9328dbfd3260a44ffd0b86277c578530e8717d27777546146e6632f62"
    sha256 cellar: :any_skip_relocation, monterey:       "6d57c0f3c2a16a0267f9cd3eab3073c778e06178a1f6a75ba83cd9b85d2aed0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ddf1c79eb09fac4884b64baa3d62825e17d419f810b5b7cc1b0b10bcc2a0f6e"
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