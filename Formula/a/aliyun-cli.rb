class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.2.13",
      revision: "1127e1a646cc571c35a7f89fb9d472215df760cf"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cfb4df5dd149f4ced33ffccb67c3f5d3bb27ffe6af4491553d72b434f335165"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cfb4df5dd149f4ced33ffccb67c3f5d3bb27ffe6af4491553d72b434f335165"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cfb4df5dd149f4ced33ffccb67c3f5d3bb27ffe6af4491553d72b434f335165"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1600f16766eb1d23eef7d23556f1caeb333520e5da1713c5978999608ae44e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3a466238e3542f29b3c2ee19babf60e74fb0b3950a97ebb5637b13243672cf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc8f044af234fecd7d3a7107f24d51684c4ac833b1238355a96ced499421be54"
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