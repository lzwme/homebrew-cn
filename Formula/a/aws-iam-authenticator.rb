class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://ghfast.top/https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.21.tar.gz"
  sha256 "177bcf252aba4a5cc753ffd527f7922c6b81daef44bd41602867b1b066c3bd65"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "38418f19aaeac44ac9e6cfe7490568690f188de1cc8fc8d588aa7948c906908a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "28cfcf513bc06f0e69e43f841fbd3e05f6e89e4ed646100f98ef21c14e1c2e4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3209be7ca4f97e9ab37bdf5a4910cb7313ea5f0842875f4bf546074fc72c9047"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "374efd2ca3973ab6883c069bef574700c36e0cdfe685200179ac9e776f745279"
    sha256 cellar: :any,                 x86_64_linux:      "2e676d74c28909591382f97d76065199c93923bfa8273cae4b3c79cd3ac63e68"
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