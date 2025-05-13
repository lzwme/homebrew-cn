class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.276",
      revision: "60736994990f68ff64a61a48c0734a10ffabe837"
  license "Apache-2.0"
  head "https:github.comaliyunaliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c39589b18263aeaf8f7591226020ee76a7e47368d732312fed923f59f0465c02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c39589b18263aeaf8f7591226020ee76a7e47368d732312fed923f59f0465c02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c39589b18263aeaf8f7591226020ee76a7e47368d732312fed923f59f0465c02"
    sha256 cellar: :any_skip_relocation, sonoma:        "59ea5da5544e14889e1428dd4e5cea7b2f7bce8f6eb3cbef528e5f84e943cdb1"
    sha256 cellar: :any_skip_relocation, ventura:       "59ea5da5544e14889e1428dd4e5cea7b2f7bce8f6eb3cbef528e5f84e943cdb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b2bce489478f781b4b7d1c3ffb53a65735ce2c8eb1797c63316ed9dc33034fd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comaliyunaliyun-cliv#{version.major}cli.Version=#{version}"
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