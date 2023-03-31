class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.160",
      revision: "b1a01235d76fb3c3fa636ee9d3f7281c3a91bafc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31128c95cd4e442dc4975cff8093cb707c6ca51e9d95e6dfc3b2db63fbab38ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31128c95cd4e442dc4975cff8093cb707c6ca51e9d95e6dfc3b2db63fbab38ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31128c95cd4e442dc4975cff8093cb707c6ca51e9d95e6dfc3b2db63fbab38ad"
    sha256 cellar: :any_skip_relocation, ventura:        "ce5cb2bba418143bea4d417c2c65531f60db99f80be0e71c87fb7d0b5eeaf531"
    sha256 cellar: :any_skip_relocation, monterey:       "ce5cb2bba418143bea4d417c2c65531f60db99f80be0e71c87fb7d0b5eeaf531"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce5cb2bba418143bea4d417c2c65531f60db99f80be0e71c87fb7d0b5eeaf531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3af77ae67023ed0868c632c9fea00dcc0b56612b9601fb317afb0a90526d377"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags: ldflags), "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end