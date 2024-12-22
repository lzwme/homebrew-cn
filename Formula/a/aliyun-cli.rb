class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.240",
      revision: "cca12006fa753ae273f8c8e29ca981e8f98b77bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "491134bf60a31b6265738d9c2e35602a04b880dc6b3dadedc3ced75122c1987e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "491134bf60a31b6265738d9c2e35602a04b880dc6b3dadedc3ced75122c1987e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "491134bf60a31b6265738d9c2e35602a04b880dc6b3dadedc3ced75122c1987e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad32dfc76ceedfc4657754240617ba2d9e1b0b02e5244a3501d271ed50fabaea"
    sha256 cellar: :any_skip_relocation, ventura:       "ad32dfc76ceedfc4657754240617ba2d9e1b0b02e5244a3501d271ed50fabaea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b814bbe34f661dce7a9c765f31b424246b347130a6920eca3ad74828757f1f8"
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