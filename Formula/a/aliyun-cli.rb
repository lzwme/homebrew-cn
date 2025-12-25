class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.2.3",
      revision: "cdccff70bad3c4b9876b95a58a6b3591c32a0774"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "836b9679faf16a6af574eb39505474652a8f829642e2fb751c2de3e6f1b82167"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "836b9679faf16a6af574eb39505474652a8f829642e2fb751c2de3e6f1b82167"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "836b9679faf16a6af574eb39505474652a8f829642e2fb751c2de3e6f1b82167"
    sha256 cellar: :any_skip_relocation, sonoma:        "456d894965cd4a6e9fd435797f642ca6b3b70166b66e0ae855b420893de5ac57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c316fa22e0b097665085b68835e105eb759da5363b979e90ddb01123b5a4c1d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7f854f6432b1c37ffc9fdc1464db1d980efdf9bc85ad35f15c84ed2b5c0eb9d"
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