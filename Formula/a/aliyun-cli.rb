class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.21",
      revision: "c2303f2e5e80324e3f30d6c9a728d6b5416d70e1"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0b77b56857f82475f29671693c4e1b609bab8109d25fd6a1831ba5242b76d76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0b77b56857f82475f29671693c4e1b609bab8109d25fd6a1831ba5242b76d76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0b77b56857f82475f29671693c4e1b609bab8109d25fd6a1831ba5242b76d76"
    sha256 cellar: :any_skip_relocation, sonoma:        "c419d86a5abedace4117341bb3495d66e5850e04e68bf04987f3e23fdb1b00de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9047041053a008996c0a62d4aa6c91b0cd1cbdad578a822402eef1b55e9a3491"
    sha256 cellar: :any,                 x86_64_linux:  "582514e3ee4d4bc1338cd87f3fd66b6b1dbf83985a3cbd100678ce8190d6454f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end