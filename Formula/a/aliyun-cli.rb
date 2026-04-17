class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.7",
      revision: "ef1439df6392a301e6070199fb4e8aaa3bff8d4a"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9e309a90dde442be8a5a3e1a46da1e1f2626857eecd4e3cc51b137a629effc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9e309a90dde442be8a5a3e1a46da1e1f2626857eecd4e3cc51b137a629effc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9e309a90dde442be8a5a3e1a46da1e1f2626857eecd4e3cc51b137a629effc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "00a0497621e9239d67177e9db18501066f3393f16eefd27a1a5627623fe33b8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3402ca5ca4ec6ba0af5b7fb473c0dd70adb9c2984dc17562a06d26d307baf0a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "233a89a560635929e9fea60f9f18408a3cbf0424ad4cbe854f575fe19445b754"
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