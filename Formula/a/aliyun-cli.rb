class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.251",
      revision: "83a89f320513edafa160a880192daf904d0ed374"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce3864e9b39804c79dfed9a94afd2e9c259c299011ac45ed67e69b32adc453df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce3864e9b39804c79dfed9a94afd2e9c259c299011ac45ed67e69b32adc453df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce3864e9b39804c79dfed9a94afd2e9c259c299011ac45ed67e69b32adc453df"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d390aae18929eaa3a2933a63239f10f6d54ab7e722ba37ed042b93a86b7000b"
    sha256 cellar: :any_skip_relocation, ventura:       "7d390aae18929eaa3a2933a63239f10f6d54ab7e722ba37ed042b93a86b7000b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da6fd65746eb733915a293ee30a132c770f1aa634b77ae5b8a69ce0a43a68a13"
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