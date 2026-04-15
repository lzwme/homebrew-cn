class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.6",
      revision: "54f8b4bc44c39c24c78f11251a55a1b8361ea02e"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af7252787ec494e562691d5ca21117a2fab0e4c69b9f180b186c010a8a26323f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af7252787ec494e562691d5ca21117a2fab0e4c69b9f180b186c010a8a26323f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af7252787ec494e562691d5ca21117a2fab0e4c69b9f180b186c010a8a26323f"
    sha256 cellar: :any_skip_relocation, sonoma:        "33919babbb222efd2c37bd3df66a14e89bcf3e193e4e9b21d6080fe1fded94e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd60cf2207ca951a3e50e5e57a60b51e88a62fde8db8348fbadc9c115965731e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c56c57c990cf018c764c4d80a12255573d51450957757b1f6603fd856d07487"
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