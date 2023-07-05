class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.169",
      revision: "7660201a554907e4583f65a8f9de9cae67dc1117"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3864fe4fcd2eeef38c5bf577eacb341befdddcf3a7fe2501258f7dec27d8c635"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3864fe4fcd2eeef38c5bf577eacb341befdddcf3a7fe2501258f7dec27d8c635"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3864fe4fcd2eeef38c5bf577eacb341befdddcf3a7fe2501258f7dec27d8c635"
    sha256 cellar: :any_skip_relocation, ventura:        "a75b247fe19e095853c7b092d1809e5e1a6321ba870c78ea84bbf0f1e9766a86"
    sha256 cellar: :any_skip_relocation, monterey:       "a75b247fe19e095853c7b092d1809e5e1a6321ba870c78ea84bbf0f1e9766a86"
    sha256 cellar: :any_skip_relocation, big_sur:        "a75b247fe19e095853c7b092d1809e5e1a6321ba870c78ea84bbf0f1e9766a86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14d347ecf3a5af89f77f48dba728ecca93f2f88a445861b3c5187fa8dd28950a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags: ldflags), "main/main.go"
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