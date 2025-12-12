class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.2.2",
      revision: "0924d7676eb0ff0cc602a0271f3938a8d3dd4520"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4928701735797ec6a76532b1612d786509f941d58b400761c81a6372d717163c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4928701735797ec6a76532b1612d786509f941d58b400761c81a6372d717163c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4928701735797ec6a76532b1612d786509f941d58b400761c81a6372d717163c"
    sha256 cellar: :any_skip_relocation, sonoma:        "52bc631a4817a1fd1b7624fa82ccad8946f954e57e85b51e05393588c2a8f168"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cce3321df1a3f39d254c2191333046284379c32383eecb6ecfc7f0c19a2a96c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e463df9faf47c74603530804d6fca7ec2f82ad3e0e61506a195477b78692a28"
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