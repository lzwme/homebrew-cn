class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.252",
      revision: "59581ab6074b35c5ce6b6febd755d31243b16649"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87646cc1798d94e26d94d83c944dc3855aca7cb4113535b54f1a2b569ec4352b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87646cc1798d94e26d94d83c944dc3855aca7cb4113535b54f1a2b569ec4352b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87646cc1798d94e26d94d83c944dc3855aca7cb4113535b54f1a2b569ec4352b"
    sha256 cellar: :any_skip_relocation, sonoma:        "99d394f192e76a467cedba8580d9a5f770d18f409061edd0b82d96dd1bc54055"
    sha256 cellar: :any_skip_relocation, ventura:       "99d394f192e76a467cedba8580d9a5f770d18f409061edd0b82d96dd1bc54055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aa272eb60a1277b0743a638a735d77e44e76cbd2bcf9e7011d17862b2bcc93e"
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