class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.2.0",
      revision: "091be99faf54fbefe4feb3c0ded8d8f36ac5cfb8"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0063c7b2fab61e759839fa380e1ddb8bd8df5307f424163687db7834424c27d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0063c7b2fab61e759839fa380e1ddb8bd8df5307f424163687db7834424c27d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0063c7b2fab61e759839fa380e1ddb8bd8df5307f424163687db7834424c27d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "80a75439eec16e4a56e5e8c74aa1acbf7e7c2a313f78f8b7e9dcbfc22a586130"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0d56a0711419e98b047f1a0c211cbe6b8cfa5d5402025c7c488a30d735adbf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "335dbf5557ceea000eb8e6db0ec7488d4b79da57f0d3cacf19938e645f50e4b6"
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