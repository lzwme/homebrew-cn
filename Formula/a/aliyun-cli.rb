class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.243",
      revision: "9787109142ceb76f49bac0f3cae3d05253bcdb6e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2ec947fc398b0381063ceba570d46dc8038ed5c87deb2c54a4ae4a39aa67035"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2ec947fc398b0381063ceba570d46dc8038ed5c87deb2c54a4ae4a39aa67035"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2ec947fc398b0381063ceba570d46dc8038ed5c87deb2c54a4ae4a39aa67035"
    sha256 cellar: :any_skip_relocation, sonoma:        "15ef9d85f01fbc0e7d8ab4cc0ce05d3b443ae8887f1ec58737671915cc771c9c"
    sha256 cellar: :any_skip_relocation, ventura:       "15ef9d85f01fbc0e7d8ab4cc0ce05d3b443ae8887f1ec58737671915cc771c9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ffa457b8b7bf1e8b43d83fb77c5d8e2165af6f285a600c77ac8ef1ecd3bc0e"
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