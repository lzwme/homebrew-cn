class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.223",
      revision: "9a1d108a0502618488b2cdf6392d22b9fae76f45"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8ce39b98bdf3ffa3ff46024f7149dd0788d19472626a2587b6c9faaedb18186"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8ce39b98bdf3ffa3ff46024f7149dd0788d19472626a2587b6c9faaedb18186"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8ce39b98bdf3ffa3ff46024f7149dd0788d19472626a2587b6c9faaedb18186"
    sha256 cellar: :any_skip_relocation, sonoma:        "d21945ac7e712c2ed27c1c585dfeda9efd29111c78365338ee3cdb80787dc318"
    sha256 cellar: :any_skip_relocation, ventura:       "d21945ac7e712c2ed27c1c585dfeda9efd29111c78365338ee3cdb80787dc318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f33ae0bfb7b7ce8985ed4dbda84c38d288ab64f2d31f371c35a1f9d6373b287"
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