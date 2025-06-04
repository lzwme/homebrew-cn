class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.281",
      revision: "246577869563236cf81ba4f5eab8ebbba870838b"
  license "Apache-2.0"
  head "https:github.comaliyunaliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a23338a1468ab810b9020158382f8cd96202d8cc06ca78155ad3ad4eb94ab2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a23338a1468ab810b9020158382f8cd96202d8cc06ca78155ad3ad4eb94ab2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a23338a1468ab810b9020158382f8cd96202d8cc06ca78155ad3ad4eb94ab2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "518930278d336b8026e65479c916ce97de5e1c2f96e6a959e009dfffccccd77b"
    sha256 cellar: :any_skip_relocation, ventura:       "518930278d336b8026e65479c916ce97de5e1c2f96e6a959e009dfffccccd77b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bba373c268f389f502a7515f2f52f6dd4c440a5fd507c55245e8cbb678f6ee56"
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