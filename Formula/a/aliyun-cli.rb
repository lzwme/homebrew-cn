class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.201",
      revision: "0c08ad2d3b98006a3cfb284ca3790ae33e5dce1c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "067d7810899ac7493916a281d94f1e39af00bed979b211e6a878b43e4d6f6099"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56cb3190545d18ea6dd78b3e7495d6727e8b9c294d550b14f0aae5370e45d8dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f6070483dccf27708d336668a29f0d70e53a5b9becc494c79a86ecb4d025de7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0bb6be778e97901203bba3c5df209c24cde907ddae4a9e2a6fc5d088839df9c"
    sha256 cellar: :any_skip_relocation, ventura:        "5937ef3cb68f5b28f53e36b5e20931eb43e19ffa3492f5c25bec954bafba6f27"
    sha256 cellar: :any_skip_relocation, monterey:       "f39d7f41ed0dc5e35aefa21125e34a14e86ef14faf3cb2dfd096e31c54247bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abb9bd5120f8c518f79d8c06c60137c6d25909f95f92be190ffd279da33e5857"
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