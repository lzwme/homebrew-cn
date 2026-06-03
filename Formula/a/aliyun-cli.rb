class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.19",
      revision: "93a19032baba8f5ce60403a4dd31e069979bda2a"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17e2dbfa9003b4678d9d3c5972debc373f75b0073aaedde0f299f6c2196d43e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17e2dbfa9003b4678d9d3c5972debc373f75b0073aaedde0f299f6c2196d43e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17e2dbfa9003b4678d9d3c5972debc373f75b0073aaedde0f299f6c2196d43e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "08b27c630cd0ec0e607000e1309bf2ee41702d9c5af8120ca1d4d446f3dee130"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8092b12785c0703eca98e6af66fbe128e466cc9faa3410d34e4ee16d005d1e6a"
    sha256 cellar: :any,                 x86_64_linux:  "e5a06446ea662c10f862b279947f392a39bf05fa2ecbaa9793fa2ed23352ca88"
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