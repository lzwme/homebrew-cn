class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.244",
      revision: "7c0ba7d21d349e90ef61acda9f223942aae7a2f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b1be08323a2612ca94b4be8fcf9788e96dd0455e688bb11c71ba362a990efc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b1be08323a2612ca94b4be8fcf9788e96dd0455e688bb11c71ba362a990efc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b1be08323a2612ca94b4be8fcf9788e96dd0455e688bb11c71ba362a990efc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1722b4d0f54c9e719bc7cc2025b88251326c5432f82954bfeb53e402d24b833b"
    sha256 cellar: :any_skip_relocation, ventura:       "1722b4d0f54c9e719bc7cc2025b88251326c5432f82954bfeb53e402d24b833b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00491249aae0234c4b82388bb51c457be12292b3ef12734cfc39616ce3440b8b"
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