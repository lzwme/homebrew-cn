class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.233",
      revision: "67fcd7f6ff9a19b3b25e678cc41288f49cfcda10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0671eef3e06176f18dc9cd5ec49e2517631d14a032ef9c4905e10f7a2076a726"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0671eef3e06176f18dc9cd5ec49e2517631d14a032ef9c4905e10f7a2076a726"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0671eef3e06176f18dc9cd5ec49e2517631d14a032ef9c4905e10f7a2076a726"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dd61dde7794fa012145178bb601f8922172e433c58b1ee9e04876546d3b8637"
    sha256 cellar: :any_skip_relocation, ventura:       "6dd61dde7794fa012145178bb601f8922172e433c58b1ee9e04876546d3b8637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2f067b48df1998471efc7e69f46d7f2b2b4937bd2a937b52e5f6d35e7ee7496"
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