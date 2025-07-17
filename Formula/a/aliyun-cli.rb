class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.290",
      revision: "682b985124e6d543e862ea1f17e922933f9144fb"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d0899b31da621517ec934190758b934eb72094610687a6366102d2b4aeb7a07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d0899b31da621517ec934190758b934eb72094610687a6366102d2b4aeb7a07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d0899b31da621517ec934190758b934eb72094610687a6366102d2b4aeb7a07"
    sha256 cellar: :any_skip_relocation, sonoma:        "85a831c1ca3f93aeb170a8defa5a778e4857ab806c923f8d16124677b681ca58"
    sha256 cellar: :any_skip_relocation, ventura:       "85a831c1ca3f93aeb170a8defa5a778e4857ab806c923f8d16124677b681ca58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04b89b04da29551d1035f37fb7a02a537fbf38d127ce772323ae656a06fcef53"
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