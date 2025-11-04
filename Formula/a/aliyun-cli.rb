class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.1.1",
      revision: "4ae725eca4daf581337383c47438e44c3c0b979f"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ea99ff5aded765e6c29aae979a5916bf78311443647de1b3273e1380c35caa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ea99ff5aded765e6c29aae979a5916bf78311443647de1b3273e1380c35caa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ea99ff5aded765e6c29aae979a5916bf78311443647de1b3273e1380c35caa4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3be87d0b23913abc28581bc347158f4b05f2202d21e2aa06ff650989beaef721"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c699339deab3c0d7bb260f24b65fe552b700839048a74516a77c6e89ce920fea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee8b23565d6d699404d48a59c05f63cdd2a9aed55e7a22a53325da70e9a0c482"
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