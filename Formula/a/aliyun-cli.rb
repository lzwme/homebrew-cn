class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.288",
      revision: "3ec2f97be218ae6e9f0f679a54f689c0ffe09fbb"
  license "Apache-2.0"
  head "https:github.comaliyunaliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "385ab0831f76c0cf2a101ca13f85b71dd4ae3d5bfd28fd56433aa86bcb87c988"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "385ab0831f76c0cf2a101ca13f85b71dd4ae3d5bfd28fd56433aa86bcb87c988"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "385ab0831f76c0cf2a101ca13f85b71dd4ae3d5bfd28fd56433aa86bcb87c988"
    sha256 cellar: :any_skip_relocation, sonoma:        "90115e26e668b5bea142ebd3c7d2584d94db93a1782994cf15398df056129f5f"
    sha256 cellar: :any_skip_relocation, ventura:       "90115e26e668b5bea142ebd3c7d2584d94db93a1782994cf15398df056129f5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7845b22ab8221893654338656a9862195327078953c7effeac5b33517affce3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comaliyunaliyun-cliv#{version.major}cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin"aliyun", ldflags:), "mainmain.go"
  end

  test do
    version_out = shell_output("#{bin}aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end