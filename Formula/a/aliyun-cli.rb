class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.306",
      revision: "1e4fd3758317df8332a4dff1cb17fc39953d3e6d"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f3568b3522dda61e04702bf5d0f22da4e75d91415736e0193f5ca3101d957d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f3568b3522dda61e04702bf5d0f22da4e75d91415736e0193f5ca3101d957d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f3568b3522dda61e04702bf5d0f22da4e75d91415736e0193f5ca3101d957d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8cbccf4b8ea00780bd49f16b81ff36cf631f8d88f36ddaa5c7ed2285f05756c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fe4f1036f4d453f5357ae128055c7272c4de8c94df6395985ee92bbb38e1b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff6309fda88d59f9829e83c30f2c6158665367f95f6fd2181dab5cba082d87fa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "main/main.go"
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