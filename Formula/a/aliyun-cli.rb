class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.1",
      revision: "06562d048f15b636fd72b1489eac5bee9d6a300a"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce3b6be3fa08637b452b8a28d651ebce12b8e41b68efe7737859962f93a11656"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce3b6be3fa08637b452b8a28d651ebce12b8e41b68efe7737859962f93a11656"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce3b6be3fa08637b452b8a28d651ebce12b8e41b68efe7737859962f93a11656"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7455abbe753f0ede2e7f17f086020fa0fbaacbf2c01f77fcb7ae59f8402161c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ccf0661587074e180733adc8a8ac62e7b767394710e854e46ad07809e1c5939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "581b35299fd83e42299ee2193a03c146e9160b2d3acf8040b747591c93dd4609"
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