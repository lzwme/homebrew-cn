class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.259",
      revision: "942b24e7571565f9d349e6446761d0a57fa04c7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b03f9abe067aae028d14b007222b0ae8a26b3a55e1033983f496fdafadb90e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b03f9abe067aae028d14b007222b0ae8a26b3a55e1033983f496fdafadb90e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b03f9abe067aae028d14b007222b0ae8a26b3a55e1033983f496fdafadb90e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "660d8128095892423f15a80ffb25753a9040b887bebd9de301301d8c496f572b"
    sha256 cellar: :any_skip_relocation, ventura:       "660d8128095892423f15a80ffb25753a9040b887bebd9de301301d8c496f572b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36008aef194acc1b32b4db370eb5c48ccc388ffdae5da0726555a08fd7076bef"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comaliyunaliyun-clicli.Version=#{version}"
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