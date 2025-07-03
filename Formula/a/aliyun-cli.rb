class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.287",
      revision: "2247bc5680430ab1dc2ab2642ab091936b96b326"
  license "Apache-2.0"
  head "https:github.comaliyunaliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f1790aecfca0561668902b002a72c29d22bd30628651c54a7c0f224da453f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6f1790aecfca0561668902b002a72c29d22bd30628651c54a7c0f224da453f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6f1790aecfca0561668902b002a72c29d22bd30628651c54a7c0f224da453f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f2012f7aedcc1295c760d1d54ec412e8ea94d275deeceefdefdfd21863575b2"
    sha256 cellar: :any_skip_relocation, ventura:       "3f2012f7aedcc1295c760d1d54ec412e8ea94d275deeceefdefdfd21863575b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a45d5fdf7c5554da2e6e2149c58d115bf43457c4308b8a353fdf983d308ccc26"
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