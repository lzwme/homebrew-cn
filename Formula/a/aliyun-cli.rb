class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.3",
      revision: "48e1eb12dceb5e2d9606fa71973090c7d55b6a81"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f591b2c7e56145f69d83c91264620f84b62b581ae15d7c5ce842f7a1b8d72f98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f591b2c7e56145f69d83c91264620f84b62b581ae15d7c5ce842f7a1b8d72f98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f591b2c7e56145f69d83c91264620f84b62b581ae15d7c5ce842f7a1b8d72f98"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ddeef6a7e46900c9fcfdc7ff42be7834996da2fa7fce25b0fa46db0f3155a28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3c40cad7b0d313e07c616950f852b8df7340a2e3bb392ba5f685f01130763b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9ef011896b8d826049851bc046d41ada24b0bd498946df2933e25551e17c697"
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