class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.262",
      revision: "a592097ed7ac2a1df6b711854f7a8b1a8b3c79b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3bec9801aaa442e27058979f29613f100e884a5f10ae35656960ff6e1afacd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3bec9801aaa442e27058979f29613f100e884a5f10ae35656960ff6e1afacd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3bec9801aaa442e27058979f29613f100e884a5f10ae35656960ff6e1afacd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a4e489910e507dcb9a4d547cb54aabb84363bcb3f249f0b082c1cda4cf48327"
    sha256 cellar: :any_skip_relocation, ventura:       "4a4e489910e507dcb9a4d547cb54aabb84363bcb3f249f0b082c1cda4cf48327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87dac9c4e3b12581065105bc2e2651cc8b0b6b210af8b59bff5633a75511f773"
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