class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://ghfast.top/https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.14.tar.gz"
  sha256 "ce3333f4c7ba5c3bb46180a854cf4bcb050d3f821ac25049d57e034ee34adb7c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26a52522eab60a6afb1a5c8128a991d8bef699ecda1bfc58c18e685162711712"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22263199bb6e07e91ce38c37d4567f699673dd8e22fdf3b2a07056ca2b659b5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5964abe94d95f43985e4a6c64867ffd37a54078ae1eb5e4cf438cd1dc58f8545"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b9a9431fc86ab9a38ee81461726caa0074470b7ddbb523e41e51faf34374555"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f3b5f238a499ae0e9e6cdf5da49df63000f8c8ae5cac1da52f94a5c2406804b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f8268e51b2d262e9c491437f6e746cc8603327c72bc6707e091635a4016ebb5"
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