class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://ghfast.top/https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.56.4.tar.gz"
  sha256 "de0d3d948cccf3e1f41977bcfe92cc2f3bd6e3abb17665aa97b5aff0c6a735cc"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "071ea4a8628a5fd90df5ded241ffdf03a7238fa95f1d5faf88209a61fbd55223"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "071ea4a8628a5fd90df5ded241ffdf03a7238fa95f1d5faf88209a61fbd55223"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "071ea4a8628a5fd90df5ded241ffdf03a7238fa95f1d5faf88209a61fbd55223"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbea8fcffe9f6fc5e23dd91fa8858f5956dbf2e79fe4c936a06bd7bcc472e2c0"
    sha256 cellar: :any_skip_relocation, ventura:       "dbea8fcffe9f6fc5e23dd91fa8858f5956dbf2e79fe4c936a06bd7bcc472e2c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "939b9db72e14e4edb179f126c04de2d1bfea8a93b8a05591c7d088bb4c349200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd0dc4a2266abc236b14c89baf2992a6c818edeb201820e6786d9271be8641e2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}
    ]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke run --config #{pkgshare}/config/testdata/example.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end