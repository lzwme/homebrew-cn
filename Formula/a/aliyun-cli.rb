class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.239",
      revision: "9da9cb6c61aa5cfb56d912d34fd1e5839e6c6584"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfd813940eac939c5d90913e8f00b1f89fd34efb824fc2df81ddf0997fa74e57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfd813940eac939c5d90913e8f00b1f89fd34efb824fc2df81ddf0997fa74e57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfd813940eac939c5d90913e8f00b1f89fd34efb824fc2df81ddf0997fa74e57"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4e29ed720fcd93b23cb14ab44c582c4066a79ec8377b11ebc347436814bcd29"
    sha256 cellar: :any_skip_relocation, ventura:       "d4e29ed720fcd93b23cb14ab44c582c4066a79ec8377b11ebc347436814bcd29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d083b868fc1682eceb23d828da044ec43c5d91a8e1705a543cf43188bc757660"
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