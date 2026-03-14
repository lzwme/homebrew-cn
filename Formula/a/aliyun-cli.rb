class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.0",
      revision: "75165d64678f9a4842d24a4f79e3a070e986264d"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b00aa0b2d94cbd84e32b71fd388641076c909893eb422b1e1e49d1feb0adeeec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b00aa0b2d94cbd84e32b71fd388641076c909893eb422b1e1e49d1feb0adeeec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b00aa0b2d94cbd84e32b71fd388641076c909893eb422b1e1e49d1feb0adeeec"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eb16ed3f04646a75cc1960f8195a4e13e230ff28e1f54e6dd50b26bbeffefcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c015f06bbef29973196fc2813a719be910c708cd9c4994f0fc3b5d5189e20a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f52d2a650448987c93f8f12168dd6c6e6e54e7acf851d05cb74fd1a16c8be3ad"
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