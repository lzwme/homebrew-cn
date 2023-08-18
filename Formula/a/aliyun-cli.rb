class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.176",
      revision: "2272e828eb9660917c8639a0b93881359f2e7d43"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d43b86a165ec107c411ec24eebf2dd0776daa5dade54b112a227f24d6373e853"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b13a9620c3ea4055923162ae5b74591721681a784a2a5ca61dfdcab66bf933bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b18cf52b63d8505fb4737b8b6d4f987135bea577b067306d94e47ee31b1b0eb7"
    sha256 cellar: :any_skip_relocation, ventura:        "83f6dda0a1441e66c3deef164f6144005eb5bc4e85eef693f4059081fa0fafba"
    sha256 cellar: :any_skip_relocation, monterey:       "be96556c33e857d9c9fa75d9bca0ee5894676f0b12136c54f5c3b7cfe68968c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c20ef7089a0ba35960e8d4b640a3a34122b1ffb54118a614e6eb5899943ccde3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94d205ee59cffdb5da9a27e7a6200fee253a5edbcaa065de8191bf3229fab732"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags: ldflags), "main/main.go"
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