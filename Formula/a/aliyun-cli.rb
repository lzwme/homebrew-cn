class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.2.4",
      revision: "b8464909af1cf8c123fbdd098ab664304ae5ac24"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2a8267f0b45a30e35700257f5a20db61eb52caa18852956dcc330bef9722032"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2a8267f0b45a30e35700257f5a20db61eb52caa18852956dcc330bef9722032"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2a8267f0b45a30e35700257f5a20db61eb52caa18852956dcc330bef9722032"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffed0f50d07421db66392347579552a109125e478bc470ca1d56c8b3f4324aba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8fbff84e41e6a0f10a9d84ebeac573fa3bede0c3c17e81b5b5d13d2cadc18fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2de23969cf4c5a93b0fb43a4d425e11c75023231b9ff79a7c5d6f61bda6d85d7"
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