class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.279",
      revision: "ff99ff27463c7727e3da00c7a979e462cc2a3ce2"
  license "Apache-2.0"
  head "https:github.comaliyunaliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ff59d5908b94806e87e4cc682c7a98a3deacea04bbaf8dd0c38e9f69e7f16dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ff59d5908b94806e87e4cc682c7a98a3deacea04bbaf8dd0c38e9f69e7f16dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ff59d5908b94806e87e4cc682c7a98a3deacea04bbaf8dd0c38e9f69e7f16dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f98032f2ed8dd3605e08360ed040789bae87f527d481dba1ac7ea318fd40696"
    sha256 cellar: :any_skip_relocation, ventura:       "4f98032f2ed8dd3605e08360ed040789bae87f527d481dba1ac7ea318fd40696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "727a54b251fab361d3913b9dfb92ae6f5c62783a538ede5e9bff74b385e7bc45"
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