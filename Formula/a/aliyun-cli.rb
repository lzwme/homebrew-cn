class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.285",
      revision: "1501013f1f287c552d4ca568e0033c6239e9cea9"
  license "Apache-2.0"
  head "https:github.comaliyunaliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1c8e4c1024709b153c145bc05e91fbe03e5f7fee1d807e94e0f2e7f3be5b60b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1c8e4c1024709b153c145bc05e91fbe03e5f7fee1d807e94e0f2e7f3be5b60b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1c8e4c1024709b153c145bc05e91fbe03e5f7fee1d807e94e0f2e7f3be5b60b"
    sha256 cellar: :any_skip_relocation, sonoma:        "72116c4905ef01ab5f9c1aecf662c5c89c940bf998c157a4f48625c15ec40201"
    sha256 cellar: :any_skip_relocation, ventura:       "72116c4905ef01ab5f9c1aecf662c5c89c940bf998c157a4f48625c15ec40201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af5a95659a51c9facfc514b3d5954062f24b5e0039c9ac33a752235f099c7193"
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