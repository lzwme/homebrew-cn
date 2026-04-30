class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.12",
      revision: "e828d81abaa2d8dc88cb643a3dfccb792cbe3ad3"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81a11880bc3f81d9e8fef9cd31dee4b1e6c014660ad746c2e94528b19fd8b4ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81a11880bc3f81d9e8fef9cd31dee4b1e6c014660ad746c2e94528b19fd8b4ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81a11880bc3f81d9e8fef9cd31dee4b1e6c014660ad746c2e94528b19fd8b4ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e9d089b2d011e37853a78229a53c6404ec0fc2070046f5b2d9a4259eb7e8e5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "101f978c65dbfdca7bf5e3543a599436b640b7a207aa75813473dd03e998ba7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94a51ce810bffa6b531761b4671b9b8873141ca6b716b6d919972438f54afad6"
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