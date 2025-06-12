class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.283",
      revision: "b7d4806a60fa9a7571889cbc91dfdc300099cb0e"
  license "Apache-2.0"
  head "https:github.comaliyunaliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ccb388993992671413570f10f504417e38e106d27d061293568b8ebb25fc221"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ccb388993992671413570f10f504417e38e106d27d061293568b8ebb25fc221"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ccb388993992671413570f10f504417e38e106d27d061293568b8ebb25fc221"
    sha256 cellar: :any_skip_relocation, sonoma:        "f48a9172d905440be1eb8e221d716fa8fc55b0185e1a2ab0a87e05f5f30ae941"
    sha256 cellar: :any_skip_relocation, ventura:       "f48a9172d905440be1eb8e221d716fa8fc55b0185e1a2ab0a87e05f5f30ae941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b055b9435a60b98b2e3f3cedb82658b94fcf439645f91619d30c2d0b92f7d42d"
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