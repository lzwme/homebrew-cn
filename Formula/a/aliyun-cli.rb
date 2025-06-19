class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.284",
      revision: "065a32cb374349c61d0d054eef2c26c2197ebe0e"
  license "Apache-2.0"
  head "https:github.comaliyunaliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80c23f376163331fb835358f8123428d9e637a2d32ff60fbc28f227b1403619c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80c23f376163331fb835358f8123428d9e637a2d32ff60fbc28f227b1403619c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80c23f376163331fb835358f8123428d9e637a2d32ff60fbc28f227b1403619c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1e359fd87cb9f231a6a028a7d46a32a1cf14b51614890b95d9afe80059f73a4"
    sha256 cellar: :any_skip_relocation, ventura:       "b1e359fd87cb9f231a6a028a7d46a32a1cf14b51614890b95d9afe80059f73a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e82840e076a6c9469bc994866de64c37d7e651e2932183d11397c61eeadd802f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comaliyunaliyun-cliv#{version.major}cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin"aliyun", ldflags:), "mainmain.go"
  end

  test do
    version_out = shell_output("#{bin}aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end