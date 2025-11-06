class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.1.2",
      revision: "43ceb85e6b8fd69325559224557f40660cfb5460"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fd31c9719d15f315982705c9af6249bd3843bed30e0512eb0c897d36be1ff03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fd31c9719d15f315982705c9af6249bd3843bed30e0512eb0c897d36be1ff03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fd31c9719d15f315982705c9af6249bd3843bed30e0512eb0c897d36be1ff03"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9581f7e43f77f7c1457ff9695701f0e192c868ecc495b02a5de5551bb3205e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04e4351b1be42bd17ce87be6e0a41417def79a0af8a48edc59eef9b31b439a93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf7afc82ed14830fae5d9885171527b3064b70fcd10648e80cd2e85fcfc0cbd4"
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