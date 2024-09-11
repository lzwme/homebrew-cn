class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.221",
      revision: "04b24bde03797cbb6dfd6b75740fa5b56c71157c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5e4d4a3bc8c218baf2402a81970aa09631d11281e810b8f1155ff0638fd600d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd83f3b21d9fbb5cbce6fb00fa3da94963b8a73ffd5d6c8fe4d8daee20d44b3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd83f3b21d9fbb5cbce6fb00fa3da94963b8a73ffd5d6c8fe4d8daee20d44b3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd83f3b21d9fbb5cbce6fb00fa3da94963b8a73ffd5d6c8fe4d8daee20d44b3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0065d6f37860d76b164a1522400bf2c4d1587311bfac132e14aaacf74d1d8d9"
    sha256 cellar: :any_skip_relocation, ventura:        "e0065d6f37860d76b164a1522400bf2c4d1587311bfac132e14aaacf74d1d8d9"
    sha256 cellar: :any_skip_relocation, monterey:       "e0065d6f37860d76b164a1522400bf2c4d1587311bfac132e14aaacf74d1d8d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddc0c5abb3be0ff35fc153dcc8dfeded94e1371fb6857d303d1192f92fa9705f"
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