class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.237",
      revision: "c89dbf006ffdba5b752a3169eee338b8b06a78cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5d806cec203e4a4e170aff4461218396f0b7c26dbd82284b28d5477c34e1d86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5d806cec203e4a4e170aff4461218396f0b7c26dbd82284b28d5477c34e1d86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5d806cec203e4a4e170aff4461218396f0b7c26dbd82284b28d5477c34e1d86"
    sha256 cellar: :any_skip_relocation, sonoma:        "00a8e2fa5d750527fb08eada4d3e34a18873e6cd58a6836d9792f38a705304de"
    sha256 cellar: :any_skip_relocation, ventura:       "00a8e2fa5d750527fb08eada4d3e34a18873e6cd58a6836d9792f38a705304de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca164811532720e109aa5121e9654e7491a7269d24bcc03928703849df5ec28f"
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