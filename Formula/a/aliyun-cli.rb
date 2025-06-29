class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.286",
      revision: "1af5741c34c913dcee3b2034fa1a48aee1e5254b"
  license "Apache-2.0"
  head "https:github.comaliyunaliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b302e1f46a0d44bc1eb778906d89f6ac239c4b95db712ad230b185ae62c27c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b302e1f46a0d44bc1eb778906d89f6ac239c4b95db712ad230b185ae62c27c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b302e1f46a0d44bc1eb778906d89f6ac239c4b95db712ad230b185ae62c27c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe197bf5e6a62f585ed192abcf6b3c8d27e5c945e7ebce0cf4bbb1680dbdda04"
    sha256 cellar: :any_skip_relocation, ventura:       "fe197bf5e6a62f585ed192abcf6b3c8d27e5c945e7ebce0cf4bbb1680dbdda04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3bf69762535234ad2ab3350a94b32b48d314fd7131cd508da24ba5fe71e1323"
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