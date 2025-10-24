class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.1.0",
      revision: "dce73667482ade542460a7afab86c8822153b271"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2243a0a35d87fe803974a68f756a289249c36a861c0936109b5667c5380070e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2243a0a35d87fe803974a68f756a289249c36a861c0936109b5667c5380070e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2243a0a35d87fe803974a68f756a289249c36a861c0936109b5667c5380070e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dd034adbcc3ba089786c782bfb2bf75574efa2cdde63d4258c0c3e873e2d033"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d356f0a8bf9185826011de270240956f238f5a1a7b8f338375c7ba60f49563a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "835d183b8e8e7fa701c93ab2648428b4414c58c8846277c7cea7569e3cb97d2b"
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