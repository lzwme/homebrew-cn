class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://aws-nuke.ekristen.dev"
  url "https://ghfast.top/https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.67.0.tar.gz"
  sha256 "69ef6d51aba9d1b875c2adae35e321e4030bf098c4bedc8c10822a99af8fc95b"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3179dd56ec752173af2e8d13c291582275d470271320f3c76cf7cb3d5dece735"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3179dd56ec752173af2e8d13c291582275d470271320f3c76cf7cb3d5dece735"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3179dd56ec752173af2e8d13c291582275d470271320f3c76cf7cb3d5dece735"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1d704d9fbfb6339abcd55cfbb0436870d43a0b3486110898c01b7520580c0e2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4316b42169e4e523d5b39c6c694d85d8fdaa7fb08a89160c3bb615d3b75a6484"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", shell_parameter_format: :cobra)
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