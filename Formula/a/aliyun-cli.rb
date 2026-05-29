class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.17",
      revision: "d8e767680812c097117bedcba92c54a1d3f04101"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc801cf5e7a1f4c866884fd3db1fc0eb5daf77203e4a74eab7f22389364de1f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc801cf5e7a1f4c866884fd3db1fc0eb5daf77203e4a74eab7f22389364de1f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc801cf5e7a1f4c866884fd3db1fc0eb5daf77203e4a74eab7f22389364de1f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6720979e782dbe9b00362bc41d6856631487b845d789e1a28b4c0a22e8a2bf11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "379aa3556e8f79ecbd65f8289cf2211f18e86bb75e559f399ac6e01a60f09c5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44abb9b284289daee40dd4f8ed342d01948fe71b256b23e64a82b2570b12a80a"
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