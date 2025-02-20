class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.254",
      revision: "c2dfdca63123db6793dbdd74ddf002564e3a6dbb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dac1661218a691528581ee238eb1e3a365f4cb8e5e341267165dd20035c3c2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dac1661218a691528581ee238eb1e3a365f4cb8e5e341267165dd20035c3c2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dac1661218a691528581ee238eb1e3a365f4cb8e5e341267165dd20035c3c2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "54d99c0bc2e8cb224b091e82a59418d3a19ea0a6eb67cf551ae7e21eb63834a6"
    sha256 cellar: :any_skip_relocation, ventura:       "54d99c0bc2e8cb224b091e82a59418d3a19ea0a6eb67cf551ae7e21eb63834a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56fa78d880d3e5538331cffe3d78524ccc70354f0fbec285f2a226b5275d0688"
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