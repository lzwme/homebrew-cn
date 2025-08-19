class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.296",
      revision: "555c5fc39c9974c751dd9664b110565fd20999ed"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3854faf200b330d624caa10221ff6ec16669b3eec6d5fe03d71c8cd772069f99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3854faf200b330d624caa10221ff6ec16669b3eec6d5fe03d71c8cd772069f99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3854faf200b330d624caa10221ff6ec16669b3eec6d5fe03d71c8cd772069f99"
    sha256 cellar: :any_skip_relocation, sonoma:        "091cf28956b9c526548a96f95ce4da632a0ec77eae608d800046b5b71a87146d"
    sha256 cellar: :any_skip_relocation, ventura:       "091cf28956b9c526548a96f95ce4da632a0ec77eae608d800046b5b71a87146d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ec7011c3735b1a0e177ca274db93517e68e0823beace1dff35fa43ec3f8681b"
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