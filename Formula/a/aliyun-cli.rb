class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.291",
      revision: "c42943dfea0ac437b0a348498c419fd30a8b3177"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb6463fc1d192fb1981373286cfe892eda62fda28f0d4d5f95bb8099a8335d25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb6463fc1d192fb1981373286cfe892eda62fda28f0d4d5f95bb8099a8335d25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb6463fc1d192fb1981373286cfe892eda62fda28f0d4d5f95bb8099a8335d25"
    sha256 cellar: :any_skip_relocation, sonoma:        "b87be178d933e55f65768ed0b49ee385f35e5046ff2798676919d07a8eac16ec"
    sha256 cellar: :any_skip_relocation, ventura:       "b87be178d933e55f65768ed0b49ee385f35e5046ff2798676919d07a8eac16ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c4e83f3369903665f1f39f67b6769fc65f700c7e204e0143706749356dfa3d9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "main/main.go"
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