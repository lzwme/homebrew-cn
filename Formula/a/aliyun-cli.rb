class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.2.10",
      revision: "868da116e012a93dc851d5897935707691ecaf6e"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c10c73bf18df9c95bbf4c851337228fdd142bcf0106e05224cc13b6a10b7e85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c10c73bf18df9c95bbf4c851337228fdd142bcf0106e05224cc13b6a10b7e85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c10c73bf18df9c95bbf4c851337228fdd142bcf0106e05224cc13b6a10b7e85"
    sha256 cellar: :any_skip_relocation, sonoma:        "028bbf89a38c10b2b14cf3cfe4b7fd8b9469179b33f7d3f62ec5061600b50abf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "667eb8ea28e071d49344570f3206229bf43d49de7145cb9457baef105a448b62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8705b1d8e24bc3a741a7564f0e1b00360b4a3af7adabc42db581b3e0ea0ef676"
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