class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://ghfast.top/https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.60.1.tar.gz"
  sha256 "297e769000b4406c7eea0250ba912b8ccd21631c67c68c879f5ed71bea9ab7af"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "963c0f0a4bab50240c74b9460384dd5abe116dd6304dc456f5478fd6b665d24c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "963c0f0a4bab50240c74b9460384dd5abe116dd6304dc456f5478fd6b665d24c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "963c0f0a4bab50240c74b9460384dd5abe116dd6304dc456f5478fd6b665d24c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4855fb717d0c491a0cc829b2245b082ddd0cc5a7f3e229a563a602a566ce0077"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18b3c13a1904e28e17eb4156b344d1449a0e923e3c8c85ac6aad411be1a5ec90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c57e85e3ced588858dd4e5b2d598094aa3574aad7eeda235e125200831ae3781"
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