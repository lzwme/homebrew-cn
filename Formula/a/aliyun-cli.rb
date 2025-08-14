class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.295",
      revision: "94adb6709c488ca6d754c54c440863abfe467e82"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "133416a11211e1c74e4120264cd85371b59c7af89219541ceac7f38f27b0da9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "133416a11211e1c74e4120264cd85371b59c7af89219541ceac7f38f27b0da9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "133416a11211e1c74e4120264cd85371b59c7af89219541ceac7f38f27b0da9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1914d2f503c6b21fc49c725b8738e4e9af4dd0e1dcd02df51f022f5a9e8d054e"
    sha256 cellar: :any_skip_relocation, ventura:       "1914d2f503c6b21fc49c725b8738e4e9af4dd0e1dcd02df51f022f5a9e8d054e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7a2af24b40271b7ecf7dbe67becb506dd71dcc4054692c75390a37998bcb14f"
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