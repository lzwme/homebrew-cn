class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.8",
      revision: "e1e08bad6adc6d756ec3df0488f02fef96d8dc7e"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30c9d3b0461650e4d9b77a3be21d15fa288bfec8cf60579c5a1b0d9cac9ba021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30c9d3b0461650e4d9b77a3be21d15fa288bfec8cf60579c5a1b0d9cac9ba021"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30c9d3b0461650e4d9b77a3be21d15fa288bfec8cf60579c5a1b0d9cac9ba021"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc87faf032c5e934f7c6d4572d2e4d772643148fce1559937f0e28bc9b2a6bed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e54db5d63def9d54bb3c4ec84b0f912987269354f3a12304e0a8f1eaa7839b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d01ecbca3c25ba1b05e3f4e6aba2716e49bb5793a0df847d27dd7d4a59579d4"
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