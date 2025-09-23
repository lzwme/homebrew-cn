class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.304",
      revision: "bb51430ec59de237c0a31a17742b7d62065e6746"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8763ef8e9ff2e6d0da376fa154509795a775587254962b6a43ba1452c20f215"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8763ef8e9ff2e6d0da376fa154509795a775587254962b6a43ba1452c20f215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8763ef8e9ff2e6d0da376fa154509795a775587254962b6a43ba1452c20f215"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea5ba755fa60a3b17b66d6d9296722f2efcdfc9e154fae05731d19b5ddd9c606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ee7f42bbb10562e6a53c54d4798b5738ecdc5fa44d38a4f90f273d3cfaa9cde"
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