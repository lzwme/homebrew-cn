class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://ghfast.top/https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.22.tar.gz"
  sha256 "c4636a1307df9d6f1b1656eb1204308bad1fa5b1f438e8f97a4534225b0b9b84"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "25c48d54b517313baa70fc083748cddb1e504a165d9464f273346f06a5bb1d4d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "199286e18e05cdce08bd8f617b86adb8f9659e7044664f2ecdc88937541f20ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1b0ecdb7c398e2b5b9e4ca096b59b6c2117bc927c3553db2fb670dcf35b3f27f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "12af7092a338e9b406a89671294ef252d9651f4b37623b288bbc812eebfaec2f"
    sha256 cellar: :any,                 x86_64_linux:      "f53ffc0991660ef88fc14d4b00efc9fa9f681f65b709563d4d3605fdb1e43ef8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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