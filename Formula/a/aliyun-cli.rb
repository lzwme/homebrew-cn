class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.307",
      revision: "a60633d3dfc233776e53a2ff2d0b28574d5ac576"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b68af5d9c8650c8c22e61cc036b6aa6f618832fd984b78077c9cf25aef13d3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b68af5d9c8650c8c22e61cc036b6aa6f618832fd984b78077c9cf25aef13d3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b68af5d9c8650c8c22e61cc036b6aa6f618832fd984b78077c9cf25aef13d3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cfddee963df458b7cab8da9854a0791cdac649ebefa19401c748af1bc4fe094"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c457645192cdf5a62c4db02538465c96d932b4bbf5d1a398d3421d53bc2bdbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b45d294324831205ecccbb7a2a12a912278fe0d8cca1266042a90bfbcfd8385"
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