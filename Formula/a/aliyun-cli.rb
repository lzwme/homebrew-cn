class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.278",
      revision: "ce0eb407d115a11cd2ba56316c10efdc2a88b66f"
  license "Apache-2.0"
  head "https:github.comaliyunaliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16474364737b12f615a715e8a0a3744471871e7199f642176f081304d37b7454"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16474364737b12f615a715e8a0a3744471871e7199f642176f081304d37b7454"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16474364737b12f615a715e8a0a3744471871e7199f642176f081304d37b7454"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b5e21becbd9e7e108a809a6f6b26e209e1d5b71b675386c00396a098d37bc7e"
    sha256 cellar: :any_skip_relocation, ventura:       "3b5e21becbd9e7e108a809a6f6b26e209e1d5b71b675386c00396a098d37bc7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40301db3cf33ba630251cd40a42a0e49207d450c4e9eff72ef84d4aa3ac9fdf3"
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