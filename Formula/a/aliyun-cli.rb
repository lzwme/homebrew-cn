class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.275",
      revision: "0f9028dda248e71fb889ab9550a0a3a34a69ad90"
  license "Apache-2.0"
  head "https:github.comaliyunaliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd55d30c12683674bf7ce1bc2e8e3777ce3fc5f8e704aacd431bea141096f3ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd55d30c12683674bf7ce1bc2e8e3777ce3fc5f8e704aacd431bea141096f3ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd55d30c12683674bf7ce1bc2e8e3777ce3fc5f8e704aacd431bea141096f3ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "88806f64c7ef80d2dd69ade72e90e832fc25f22893cae77ca380bbd9a6bfd314"
    sha256 cellar: :any_skip_relocation, ventura:       "88806f64c7ef80d2dd69ade72e90e832fc25f22893cae77ca380bbd9a6bfd314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96bc56c7bcb68166a620464847edd14c526c67a89eee40315c096b6aa8f2fb68"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comaliyunaliyun-cliv#{version.major}cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin"aliyun", ldflags:), "mainmain.go"
  end

  test do
    version_out = shell_output("#{bin}aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end