class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.238",
      revision: "cde2473c8d26c8f410784d0cab6e7d3995677d65"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a29fa5a4584fb0a110c756c615a8ab7c9e1d5bae4cb3e3db9c4aa4e58735c5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a29fa5a4584fb0a110c756c615a8ab7c9e1d5bae4cb3e3db9c4aa4e58735c5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a29fa5a4584fb0a110c756c615a8ab7c9e1d5bae4cb3e3db9c4aa4e58735c5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ba62a280bff208dee49a6b7ea10ad69b36437ab580e013387f292b0620efece"
    sha256 cellar: :any_skip_relocation, ventura:       "2ba62a280bff208dee49a6b7ea10ad69b36437ab580e013387f292b0620efece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2afb7ec3a852c822b1361cc44f93b2bec421554d8d26922f9466bfdf4067870b"
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