class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.241",
      revision: "dc542af59502b79972b7c1208f3d0e9bc6f65b1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e79c0f9a09b776e211b3aa663adcca2a821927e270abd27e6000e5b08c179187"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e79c0f9a09b776e211b3aa663adcca2a821927e270abd27e6000e5b08c179187"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e79c0f9a09b776e211b3aa663adcca2a821927e270abd27e6000e5b08c179187"
    sha256 cellar: :any_skip_relocation, sonoma:        "b38c424bc164992f195f153e5d53a95a05ae95bb03568467629fe21fccc956ea"
    sha256 cellar: :any_skip_relocation, ventura:       "b38c424bc164992f195f153e5d53a95a05ae95bb03568467629fe21fccc956ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daed6c1945a46675504cc363e4fb8012cf56267dd5bc9ab9952353d117a11408"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comaliyunaliyun-clicli.Version=#{version}"
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