class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.245",
      revision: "ff9b905cc7dba2862fbb217d551a42cb5ad71644"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15f1728bffe1204ccb69d62f51116bf0255359132cef223bf9cc77f8625d6545"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15f1728bffe1204ccb69d62f51116bf0255359132cef223bf9cc77f8625d6545"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15f1728bffe1204ccb69d62f51116bf0255359132cef223bf9cc77f8625d6545"
    sha256 cellar: :any_skip_relocation, sonoma:        "627444e55a1e946c66e6c334780c5159da754e5190d12721616f18d18f149935"
    sha256 cellar: :any_skip_relocation, ventura:       "627444e55a1e946c66e6c334780c5159da754e5190d12721616f18d18f149935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6f2c13c41c9ca7562909ad07853aa73ad23818be17035513f22c9c4a142bdda"
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