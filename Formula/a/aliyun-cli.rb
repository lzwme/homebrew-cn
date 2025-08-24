class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.298",
      revision: "e9611a56dbd5b686c3681e415a95e89e2f9d6e82"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc72f6a63dee7e11c7c21d062cf43b335e5b881b8d47e5e2024317ed6f2c93e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc72f6a63dee7e11c7c21d062cf43b335e5b881b8d47e5e2024317ed6f2c93e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc72f6a63dee7e11c7c21d062cf43b335e5b881b8d47e5e2024317ed6f2c93e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6cacfe828e634c00d5a7edd450345a9b3eafeae9abd6b671a48b17934120e1f"
    sha256 cellar: :any_skip_relocation, ventura:       "a6cacfe828e634c00d5a7edd450345a9b3eafeae9abd6b671a48b17934120e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6fb0d550307fe168febc3a25c67f2612c5d3e8916ff187001b3102a833dd808"
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