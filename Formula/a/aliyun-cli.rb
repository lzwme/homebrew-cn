class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.253",
      revision: "95ab966bd1c8484f27167cb1012c5e4d5ad55c58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48eebf581518a41e7e7bf3e35068cd5efa9a1b322d49d2a7c58cdc74995dc9db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48eebf581518a41e7e7bf3e35068cd5efa9a1b322d49d2a7c58cdc74995dc9db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48eebf581518a41e7e7bf3e35068cd5efa9a1b322d49d2a7c58cdc74995dc9db"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a73994f75ffcd3e95990c8a11c22373fc42f30043d4deab49435888141329f9"
    sha256 cellar: :any_skip_relocation, ventura:       "1a73994f75ffcd3e95990c8a11c22373fc42f30043d4deab49435888141329f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2897cde33b30cec372cff382142d0c85daef03b7359cf2e188d16cc28967bbfa"
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