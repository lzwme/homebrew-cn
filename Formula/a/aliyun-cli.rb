class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.11",
      revision: "e1c6eef8d0858a36ca4689c9074eb7f4cf1bbfb5"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0333f094f84d0b40905e4c62b65482dbc6bd32b86358228261c699d589764533"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0333f094f84d0b40905e4c62b65482dbc6bd32b86358228261c699d589764533"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0333f094f84d0b40905e4c62b65482dbc6bd32b86358228261c699d589764533"
    sha256 cellar: :any_skip_relocation, sonoma:        "78d8bf00342ed0c286c16642ea188f13d5d5e1f0fcd6afb98445c08cb7125861"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bff5e93a4bd2b5f561148283c78c8d46362db219f73fc5fe72036fd1379f5f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c4322c13d3e069bd0686d6df7d41ac34a793018ae9e26c9273de22c07ff7d7f"
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