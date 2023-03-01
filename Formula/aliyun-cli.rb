class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.151",
      revision: "feae19f6a7470243706da9fca717faa19fc06e1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4415c679b5b801c25befa4c1e38fb9c6a21bbe6eb7e2aa75ab658cc9639cec79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4415c679b5b801c25befa4c1e38fb9c6a21bbe6eb7e2aa75ab658cc9639cec79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4415c679b5b801c25befa4c1e38fb9c6a21bbe6eb7e2aa75ab658cc9639cec79"
    sha256 cellar: :any_skip_relocation, ventura:        "09d99a0fe567b65fa0c04e6b921b8f83087f212892fb30be7e997fa7631fb741"
    sha256 cellar: :any_skip_relocation, monterey:       "09d99a0fe567b65fa0c04e6b921b8f83087f212892fb30be7e997fa7631fb741"
    sha256 cellar: :any_skip_relocation, big_sur:        "09d99a0fe567b65fa0c04e6b921b8f83087f212892fb30be7e997fa7631fb741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96a089086d050cab6ce504452200c53269161a89300666a2f2bb0968c8bf1107"
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