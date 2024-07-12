class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.212",
      revision: "79d382b92fb3df47449380f4d42718b60b402595"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd4ce0c6d564eef4d4993050b9fed3558be54e6d3fcd8f94a46f72fe12ee70ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af766c2e33e4150564a7f75f725b7230d8bf5d6150c014e3ba5f3eecad31ec4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfaac1b29187ca38e9a2a2586a33671a72fc902659e102eb193a707c20c60835"
    sha256 cellar: :any_skip_relocation, sonoma:         "125a9b938728712b6d70186167be14eb88f3ed4bb88526b69cf612d248aec83d"
    sha256 cellar: :any_skip_relocation, ventura:        "185e1aa38c56a0cde84f49214523aedb9a1e70b283fd67a7b124c0072253b2b0"
    sha256 cellar: :any_skip_relocation, monterey:       "9ee471aed71acb2798d2604f701c2bd86ab1fe60311f85d54a9b28dcb4e1d3b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "421e5ef453f7994ceaa1f1d9302e58593a0d9cedb6bf2595f494e7951b69ca02"
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