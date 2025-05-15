class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.277",
      revision: "adfed63c333440b23888237e22142550c1fb8087"
  license "Apache-2.0"
  head "https:github.comaliyunaliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b1f1bb0e1b6d5a0f86ce7fd5d41bcb55f71e777f5fdb79bddc178a32043e2a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b1f1bb0e1b6d5a0f86ce7fd5d41bcb55f71e777f5fdb79bddc178a32043e2a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b1f1bb0e1b6d5a0f86ce7fd5d41bcb55f71e777f5fdb79bddc178a32043e2a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b01d19dd83a831ee5b49bbc2588aeecde702e026f69434ecd25c25b1989ff85"
    sha256 cellar: :any_skip_relocation, ventura:       "2b01d19dd83a831ee5b49bbc2588aeecde702e026f69434ecd25c25b1989ff85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d622ad569653d58a93461d6a959ebc9d13a09cbd23de17fae40ef7fb169b22e"
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