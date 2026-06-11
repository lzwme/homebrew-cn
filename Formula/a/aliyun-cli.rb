class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.23",
      revision: "9eed7202cf6659c08c0cf223e2707d7888b054bc"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31ef3a91608627825464ee7cff1a82a92b1d27d8f5411e02ca6999ad8c44b835"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31ef3a91608627825464ee7cff1a82a92b1d27d8f5411e02ca6999ad8c44b835"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31ef3a91608627825464ee7cff1a82a92b1d27d8f5411e02ca6999ad8c44b835"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e21b84e2c54e74a5fe9798fc4edd40e7c465d25798be3d93d3ba8dc4cfad4e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72498868287db7473ce0065346d5e344c689fc36cdbc31a2a72c2eb9d73056c5"
    sha256 cellar: :any,                 x86_64_linux:  "48f20c3f9ca136335038979e3225f308995edc91ec301d31b5bf0254193168b4"
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