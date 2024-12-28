class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.242",
      revision: "4e18be8e7b2fefc646b6d1777e6ff718419fbb6f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81c1252c162c500c455a138f9a5766f82fc30e5f3ad39052a81b1a9e66597223"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81c1252c162c500c455a138f9a5766f82fc30e5f3ad39052a81b1a9e66597223"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81c1252c162c500c455a138f9a5766f82fc30e5f3ad39052a81b1a9e66597223"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e277c1d55932d7228ddf3067ecea10b4de80795225a9d252a65ad73d6474120"
    sha256 cellar: :any_skip_relocation, ventura:       "4e277c1d55932d7228ddf3067ecea10b4de80795225a9d252a65ad73d6474120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8280856250aa784487b8cb57fda7fea881e660ca2e0b6d32d2dd57b2581031f1"
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