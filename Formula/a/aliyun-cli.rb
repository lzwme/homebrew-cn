class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.294",
      revision: "b9c06b6cca94300e955bf0e2573cf0ba00a8e545"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "472926db9534f2f797e2acae178dfa3470ab457b1cc6f91d384fd5a6df522819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "472926db9534f2f797e2acae178dfa3470ab457b1cc6f91d384fd5a6df522819"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "472926db9534f2f797e2acae178dfa3470ab457b1cc6f91d384fd5a6df522819"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d9924843fba0fd102a9c92ffdcc7f89ea9a2978d8e16ad964390a42ba293eeb"
    sha256 cellar: :any_skip_relocation, ventura:       "8d9924843fba0fd102a9c92ffdcc7f89ea9a2978d8e16ad964390a42ba293eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2169ce8bb4ac2f6a5c169c16315e1f20dd57cad2d107836b0a16baf97bba4721"
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