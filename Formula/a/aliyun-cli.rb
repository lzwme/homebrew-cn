class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.2.12",
      revision: "8313a0794d92e58c0cf0bf29c980db4dcebc1a05"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "051b8300f79519cee7bd6b49e4a79217740bbf137cdc44b94e2d44084d8fbc0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "051b8300f79519cee7bd6b49e4a79217740bbf137cdc44b94e2d44084d8fbc0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "051b8300f79519cee7bd6b49e4a79217740bbf137cdc44b94e2d44084d8fbc0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "88f8083efe9977aa607228fb8db66df9296b0299822c919d731619e5bd6a8d87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24d6dc717f88e741b549e80add0f0358a79fd3fa58548f84d628671b3cefb231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70465745f35ad5c630a8c3d7d3963172e057c5c68ffdd7c99b837a161afe2eaa"
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