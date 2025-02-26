class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.255",
      revision: "b5a8bebfd5809be984f1c9ffe35cf25bcb3bd2b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "650886f97877a96b18d9e6b1c8272eb748e03ee67b66daba5c795b452703805b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "650886f97877a96b18d9e6b1c8272eb748e03ee67b66daba5c795b452703805b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "650886f97877a96b18d9e6b1c8272eb748e03ee67b66daba5c795b452703805b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac3901bfb504a456ea4a8c1ed76a31c189e0234e4f92bd7c4f087b4176d09af0"
    sha256 cellar: :any_skip_relocation, ventura:       "ac3901bfb504a456ea4a8c1ed76a31c189e0234e4f92bd7c4f087b4176d09af0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a1cf739fad3482a0dc4b4285543a4fb23721c40987a9fa88c87c1b00e9a1390"
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