class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.268",
      revision: "3e446ee65d936d319416ca1179b72ec0c8651472"
  license "Apache-2.0"
  head "https:github.comaliyunaliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd11d3289218d80a4c5a290019b5d5d49d6caf18e98766c13a5e36d8eeb8f802"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd11d3289218d80a4c5a290019b5d5d49d6caf18e98766c13a5e36d8eeb8f802"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd11d3289218d80a4c5a290019b5d5d49d6caf18e98766c13a5e36d8eeb8f802"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5bf17bd0f77795b73233d332d2f5d2cbe5f8c675755fbe4b771cb8c025129ad"
    sha256 cellar: :any_skip_relocation, ventura:       "d5bf17bd0f77795b73233d332d2f5d2cbe5f8c675755fbe4b771cb8c025129ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71f4e220d46b22b989e111ed5cbbbf4ef93431e193914ce38c7fde04595cd4c4"
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