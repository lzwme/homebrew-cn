class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.2.11",
      revision: "a3f7760db03b2eaf14043b1dbec1e9e4c75ad6b8"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f3196a51cc583ae761f5826ac4dbb554c34602e3e7a6da33145d37da4a7b05a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f3196a51cc583ae761f5826ac4dbb554c34602e3e7a6da33145d37da4a7b05a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f3196a51cc583ae761f5826ac4dbb554c34602e3e7a6da33145d37da4a7b05a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce1f9ec620cd099dbd8dfa52abe621d5ea634a35d22e7aef1bf4bdb7f9689eea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bb099c9119313b971011b20028990ccfca10a1afc5ea2b27706d83f6a92b6c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aad2d0e205b702983b3db0293d8d44bac853152411a9dce60753d22cdd0ddcdc"
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