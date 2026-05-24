class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.16",
      revision: "b094d409a92148c946fed89abd65be2720c5693c"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0b734ca7306bda9556763c7046423ed0e4518f1fc0532553599d45d1b968873"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0b734ca7306bda9556763c7046423ed0e4518f1fc0532553599d45d1b968873"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0b734ca7306bda9556763c7046423ed0e4518f1fc0532553599d45d1b968873"
    sha256 cellar: :any_skip_relocation, sonoma:        "a494d5efcccdd4b73bd68084d5e6b4acc87c5d4d3e57cc63d9b6c878209c6bd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1779714094b1ff30ed206cf77b82ad4cd0db37e2f9e7b6d8971bfdd855533310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "263d232023339b97eda2f5370465bdfe9e19f9ec100bf508743fa1cf1bebe586"
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