class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.308",
      revision: "7c58a459b20bb5933676d0d81f596063571baa67"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85b3fc248881011b350152652f3b68a4b941dd61b05a6dd437dcb542754f8749"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85b3fc248881011b350152652f3b68a4b941dd61b05a6dd437dcb542754f8749"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85b3fc248881011b350152652f3b68a4b941dd61b05a6dd437dcb542754f8749"
    sha256 cellar: :any_skip_relocation, sonoma:        "191a290991a64437288da73c3472077a65174b3de27cc2a489cba3e443230c99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58bd915dfa9eb8880d746dce5f870a61157b92c043ad94afc15e15b83ca931ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6753faea6ed728ee9c16041bc4592de71d1a4508edf6319fbd11671a6702307a"
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