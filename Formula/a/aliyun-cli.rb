class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.170",
      revision: "2b13c95a16017a18fa9469de372c2553c3f8897b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3decf7e372dd0401476f53a8be3d6898a47b8d6f5b35e449d541becea477cd89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3decf7e372dd0401476f53a8be3d6898a47b8d6f5b35e449d541becea477cd89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3decf7e372dd0401476f53a8be3d6898a47b8d6f5b35e449d541becea477cd89"
    sha256 cellar: :any_skip_relocation, ventura:        "42db6da5e346c23fd1bb7a57e67a84bcd737794734bc99bf0f49fa90d566062d"
    sha256 cellar: :any_skip_relocation, monterey:       "42db6da5e346c23fd1bb7a57e67a84bcd737794734bc99bf0f49fa90d566062d"
    sha256 cellar: :any_skip_relocation, big_sur:        "42db6da5e346c23fd1bb7a57e67a84bcd737794734bc99bf0f49fa90d566062d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c08600fa2476986cd848bb1be078fb8103b2bbcb8a27ee480d0917548658a771"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags: ldflags), "main/main.go"
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