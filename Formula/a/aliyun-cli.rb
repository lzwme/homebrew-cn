class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.246",
      revision: "33378a6c3ac51e26b93e9fa9132b67155208326f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d0301d93bd1edaba03eb433a3c5d4e3335ef018b856f6654ba9302cef652cdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d0301d93bd1edaba03eb433a3c5d4e3335ef018b856f6654ba9302cef652cdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d0301d93bd1edaba03eb433a3c5d4e3335ef018b856f6654ba9302cef652cdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "52925793b4106306c2d5acef3e47e373051083855beafef56f5baa9e58c5ef36"
    sha256 cellar: :any_skip_relocation, ventura:       "52925793b4106306c2d5acef3e47e373051083855beafef56f5baa9e58c5ef36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "686ee04256718794a947c0a5c0a9c730744042c7fc6edbdec3799ce683f47c62"
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